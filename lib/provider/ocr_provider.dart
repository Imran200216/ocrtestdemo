import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ocrtestdemo/components/custom_snack_bar.dart';

class OCRProvider extends ChangeNotifier {
  String? _pickedFilePath; // For native platforms
  Uint8List? _pickedFileBytes; // For web platform
  bool _isLoading = false; // Loading state

  String? get pickedFilePath => _pickedFilePath;

  Uint8List? get pickedFileBytes => _pickedFileBytes;

  bool get isLoading => _isLoading;

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

        /// show success snack bar
        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: 'Success!',
          message: 'Image picked successfully!',
        );
      } else {
        /// show error snack bar
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

  void clearFile(BuildContext context) {
    _pickedFilePath = null;
    _pickedFileBytes = null;
    _isLoading = false;

    /// show success snack bar
    CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
      context: context,
      title: 'Success!',
      message: 'Image deleted successfully!',
    );

    notifyListeners();
  }
}
