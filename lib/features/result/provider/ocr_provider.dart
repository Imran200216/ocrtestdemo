import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
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

  /// picking an image
  Future<void> pickImage(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedImage != null) {
        if (kIsWeb) {
          // For web, use the image as bytes
          _pickedFileBytes = await pickedImage.readAsBytes();
          _pickedFilePath = null; // No file path on web
        } else {
          // For native platforms, use the image file path
          _pickedFilePath = pickedImage.path;
          _pickedFileBytes = await pickedImage.readAsBytes();
        }

        debugPrint('Picked File Path: $_pickedFilePath');
        debugPrint('Picked File Bytes Length: ${_pickedFileBytes?.length}');

        // Success notification
        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: 'Success!',
          message: 'Image picked successfully!',
        );
      } else {
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: 'Error!',
          message: 'No image selected!',
        );
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Error!',
        message: 'Failed to pick an image. Please try again!',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// uploading an image
  Future<void> uploadImage(BuildContext context) async {
    if (_pickedFileBytes == null && _pickedFilePath == null) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Error!',
        message: 'No image selected for upload!',
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
        // Upload image bytes for web
        await _supabase.storage
            .from(bucket)
            .uploadBinary(fileName, _pickedFileBytes!);
      } else if (_pickedFilePath != null) {
        // Upload image file path for mobile/tablet
        final file = File(_pickedFilePath!);
        await _supabase.storage.from(bucket).upload(fileName, file);
      }

      CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
        context: context,
        title: 'Upload Success!',
        message: 'Image uploaded to Supabase successfully!',
      );
    } catch (e) {
      debugPrint("Error uploading image: $e");
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: 'Upload Failed!',
        message: 'Failed to upload the image. Please try again!',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// clearing an image
  void clearImage(BuildContext context) {
    _pickedFilePath = null;
    _pickedFileBytes = null;
    _isLoading = false;

    CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
      context: context,
      title: 'Success!',
      message: 'Image cleared successfully!',
    );

    notifyListeners();
  }

  Future<void> processBusinessCard(BuildContext context, File? image) async {
    setProcessing(true);

    try {
      // Handle the web-specific case
      if (kIsWeb && _pickedFileBytes != null) {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_image.jpg');
        await tempFile.writeAsBytes(_pickedFileBytes!);
        image = tempFile; // Use the tempFile created from bytes for web
      }

      // Handle the native platform case
      if (!kIsWeb && image == null && _pickedFilePath != null) {
        image = File(_pickedFilePath!); // Use file path on mobile platforms
      }

      // Check if a valid image is available
      if (image == null || !await image.exists()) {
        throw Exception('No valid image selected for processing!');
      }

      // Process the image with Google ML Kit's text recognizer
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract entities using the entity extractor
      final List<EntityAnnotation> extractEntities =
          await _entityExtractor.annotateText(
        recognizedText.text,
        entityTypesFilter: [
          EntityType.email,
          EntityType.phone,
          EntityType.address,
          EntityType.url,
          EntityType.unknown,
        ],
      );

      // Initialize variables for storing extracted data
      String? phoneNumber;
      String? emailAddress;
      String? companyName;
      String? companyAddress;
      String? personName;
      String? others;
      String? companyWebsite;

      // Extract data from the entity annotations
      for (final entity in extractEntities) {
        if (entity.entities.isNotEmpty) {
          switch (entity.entities.first.type) {
            case EntityType.unknown:
              others ??= entity.text;
              break;
            case EntityType.phone:
              phoneNumber ??= entity.text;
              break;
            case EntityType.email:
              emailAddress ??= entity.text;
              break;
            case EntityType.address:
              companyAddress ??= entity.text;
              break;
            case EntityType.url:
              companyWebsite ??= entity.text;
              break;
            default:
              break;
          }
        }
      }

      // Assign recognized text to additional fields if not found in entities
      if (recognizedText.blocks.isNotEmpty) {
        personName ??= recognizedText.blocks.first.text.split('\n').first;
        companyName ??= recognizedText.blocks.length > 1
            ? recognizedText.blocks[1].text.split('\n').first
            : null;
      }

      // Upload the image to Supabase Storage
      final filePath = 'images/${DateTime.now().toIso8601String()}.jpg';
      final String uploadedPath =
          await _supabase.storage.from('images').upload(filePath, image);

      // Insert structured data into the database
      final response = await _supabase.from('business_card_data').insert({
        'image_url': uploadedPath,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'companyName': companyName,
        'companyAddress': companyAddress,
        'personName': personName,
        'companyWebsite': companyWebsite,
        'others': others,
      });

      // Check for errors in the response
      if (response.error != null) {
        throw Exception(
            'Error inserting data into Supabase: ${response.error.message}');
      }

      // Success notification
      CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
        context: context,
        title: "Success",
        message: 'Business card processed and saved successfully!',
      );
    } catch (e) {
      debugPrint("Error in processBusinessCard: $e");
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Error in processing",
        message: e.toString(),
      );
    } finally {
      setProcessing(false);
    }
  }
}
