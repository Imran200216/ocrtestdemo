import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:ocrtestdemo/commons/custom_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OCRProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  final _entityExtractor =
      GoogleMlKit.nlp.entityExtractor(EntityExtractorLanguage.english);
  final _textRecognizer = GoogleMlKit.vision.textRecognizer();

  String? _pickedFilePath; // For native platforms
  Uint8List? _pickedFileBytes; // For web platform
  bool _isLoading = false; // Loading state
  bool _isProcessing = false; // Processing state

  String? get pickedFilePath => _pickedFilePath;

  Uint8List? get pickedFileBytes => _pickedFileBytes;

  bool get isLoading => _isLoading;

  bool get isProcessing => _isProcessing;

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> pickFile(BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners to show loading state

    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Check if running on the web
        if (result.files.first.bytes != null) {
          _pickedFileBytes = result.files.first.bytes;
          _pickedFilePath = null; // Clear file path for web
        } else {
          _pickedFilePath = result.files.first.path;
          _pickedFileBytes = null; // Clear bytes for native
        }

        /// Show success snack bar
        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: 'Success!',
          message: 'Image picked successfully!',
        );
      } else {
        /// Show error snack bar
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: 'Error!',
          message: 'Please pick an image to proceed!',
        );
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners to hide loading state
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (_pickedFilePath == null && _pickedFileBytes == null) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Error!',
        message: 'No file selected for upload!',
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      const bucket = 'images';
      final fileName =
          'uploaded_image_${DateTime.now().millisecondsSinceEpoch}';

      if (_pickedFileBytes != null) {
        // Upload for web platform
        await _supabase.storage.from(bucket).uploadBinary(
              fileName,
              _pickedFileBytes!,
            );
      } else if (_pickedFilePath != null) {
        // Upload for native platform
        final file =
            File(_pickedFilePath!); // Convert the file path to a File object
        await _supabase.storage.from(bucket).upload(
              fileName,
              file,
            );
      }

      CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
        context: context,
        title: 'Upload Success!',
        message: 'Image uploaded to Supabase successfully!',
      );
    } catch (e) {
      debugPrint("Error uploading file: $e");
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Upload Failed!',
        message: 'Failed to upload the file. Please try again!',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFile(BuildContext context) {
    _pickedFilePath = null;
    _pickedFileBytes = null;
    _isLoading = false;

    /// Show success snack bar
    CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
      context: context,
      title: 'Success!',
      message: 'Image deleted successfully!',
    );

    notifyListeners();
  }

  Future<void> processBusinessCard(BuildContext context, File? image) async {
    // Check if the image is null
    if (image == null || !await image.exists()) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Error!',
        message: 'No valid image selected for processing!',
      );
      return;
    }

    setProcessing(true); // Start processing by setting the state

    try {
      // Recognize text from the image
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract entities from the recognized text
      final List<EntityAnnotation> extractEntities =
          await _entityExtractor.annotateText(
        recognizedText.text,
        entityTypesFilter: [
          EntityType.email,
          EntityType.phone,
          EntityType.address,
          EntityType.unknown,
          EntityType.url,
        ],
      );

      // Organize entities into a Map
      final Map<String, List<String>> extractedData = {};
      for (var entity in extractEntities) {
        for (var type in entity.entities) {
          final key = type.type.toString();
          extractedData[key] = (extractedData[key] ?? [])..add(type.rawValue);
        }
      }

      // Upload the image to Supabase Storage
      final filePath = 'images/${DateTime.now().toIso8601String()}.jpg';
      final String uploadedPath = await _supabase.storage
          .from('images') // Replace with your bucket name
          .upload(filePath, image);

      // Save data in Supabase database
      await _supabase.from('business_card_data').insert({
        'image_url': uploadedPath,
        'entities': json.encode(extractedData),
        // Encoding the extracted data as JSON
      });

      CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
        context: context,
        title: "Success",
        message: 'Business card processed successfully!',
      );
    } catch (e) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Error in processing",
        message: e.toString(),
      );
    } finally {
      setProcessing(false); // Stop processing by resetting the state
    }
  }
}
