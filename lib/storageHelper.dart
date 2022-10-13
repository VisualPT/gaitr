import 'dart:developer';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:video_compress/video_compress.dart';

late Map<String, dynamic> userData = {};

void storeValue(String field, String? value) {
  try {
    switch (field) {
      case "First Name":
        userData[field] = value;
        break;
      case "Last Name":
        userData[field] = value;
        break;
      case "Birth Date":
        userData[field] = value;
        break;
      default:
        throw Exception("Invalid field or value used");
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<void> uploadFile(File file) async {
  MediaInfo? mediaInfo = await VideoCompress.compressVideo(
    file.path,
    quality: VideoQuality.DefaultQuality,
  );

  final options = S3UploadFileOptions(contentType: 'video/mp4');

  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(mediaInfo!.path!),
        key: 'Gait Video', //TODO Make unique
        options: options,
        onProgress: (progress) {
          print("Fraction completed: " +
              progress.getFractionCompleted().toString());
        });
    print('Successfully uploaded file: ${result.key}');
  } on StorageException catch (e) {
    print('Error uploading file: $e');
  }
}
