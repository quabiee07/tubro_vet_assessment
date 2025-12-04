// lib/core/services/image_picker_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress image
      );

      if (image == null) return null;

      // Save image to app directory
      final String savedPath = await _saveImageToLocalStorage(image.path);
      return savedPath;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (photo == null) return null;

      final String savedPath = await _saveImageToLocalStorage(photo.path);
      return savedPath;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  Future<String> _saveImageToLocalStorage(String imagePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
    final String localPath = path.join(appDir.path, 'images', fileName);

    // Create images directory if it doesn't exist
    final Directory imageDir = Directory(path.join(appDir.path, 'images'));
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // Copy image to app directory
    final File imageFile = File(imagePath);
    await imageFile.copy(localPath);

    return localPath;
  }
}