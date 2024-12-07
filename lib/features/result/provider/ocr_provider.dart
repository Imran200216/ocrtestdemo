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
        if (result.files.first.bytes != null) {
          _pickedFileBytes = result.files.first.bytes;
          _pickedFilePath = null; // Clear file path for web
        } else {
          _pickedFilePath = result.files.first.path;
          _pickedFileBytes = null; // Clear bytes for native
        }

        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: 'Success!',
          message: 'Image picked successfully!',
        );
      } else {
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
      notifyListeners();
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
        await _supabase.storage.from(bucket).uploadBinary(
              fileName,
              _pickedFileBytes!,
            );
      } else if (_pickedFilePath != null) {
        final file = File(_pickedFilePath!);
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

    CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
      context: context,
      title: 'Success!',
      message: 'Image deleted successfully!',
    );

    notifyListeners();
  }

  Future<void> processBusinessCard(BuildContext context, File? image) async {
    setProcessing(true);

    try {
      // Handle image for both web and native platforms
      if (image == null && _pickedFileBytes != null) {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_image.jpg');
        await tempFile.writeAsBytes(_pickedFileBytes!);
        image = tempFile;
      }

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

      // Initialize a structured data map
      final Map<String, List<Map<String, String>>> structuredData = {
        'contacts': [],
        'addresses': [],
        'general': [],
        'social_media': [],
        'others': [],
      };

      // Add extracted entities to the corresponding categories
      for (final entity in extractEntities) {
        if (entity.text.isNotEmpty) {
          final String type =
              _mapEntityTypeToCustomType(entity.entities.first.type);
          final Map<String, String> entityData = {
            'data': entity.text,
            'type': type,
          };

          switch (type) {
            case 'Email':
              structuredData['contacts']?.add(entityData);
              break;
            case 'Phone Number':
              structuredData['contacts']?.add(entityData);
              break;
            case 'Company Destination':
              structuredData['addresses']?.add(entityData);
              break;
            case 'Company Website':
              structuredData['social_media']?.add(entityData);
              break;
            default:
              structuredData['others']?.add(entityData);
          }
        }
      }

      // Avoid duplications by adding recognized text blocks into 'general' category
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          if (!structuredData['general']!
              .any((item) => item['data'] == line.text)) {
            structuredData['general']
                ?.add({'data': line.text, 'type': 'General'});
          }
        }
      }

      // Ensure structuredData has valid entries before proceeding
      // Ensure structuredData has valid entries before proceeding
      if (structuredData.isEmpty ||
          (structuredData['contacts']?.isEmpty ?? true) &&
              (structuredData['addresses']?.isEmpty ?? true) &&
              (structuredData['social_media']?.isEmpty ?? true) &&
              (structuredData['others']?.isEmpty ?? true)) {
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "No Entities Found",
          message: "The image does not contain recognizable data.",
        );
        return;
      }

      // Upload the image to Supabase Storage
      final filePath = 'images/${DateTime.now().toIso8601String()}.jpg';
      final String uploadedPath =
          await _supabase.storage.from('images').upload(filePath, image);

      // Insert structured data into the database using .select()
      final response = await _supabase.from('business_card_data').insert({
        'image_url': uploadedPath,
        'entities': json.encode(structuredData),
      }).single();

      if (response.toString() != null) {
        throw Exception(
            'Error inserting data into Supabase: ${response.toString()}');
      }

      CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
        context: context,
        title: "Success",
        message: 'Business card processed successfully!',
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

  String _mapEntityTypeToCustomType(EntityType type) {
    switch (type) {
      case EntityType.email:
        return 'Email';
      case EntityType.address:
        return 'Company Destination';
      case EntityType.phone:
        return 'Phone Number';
      case EntityType.url:
        return 'Company Website';
      default:
        return 'Others';
    }
  }
}
