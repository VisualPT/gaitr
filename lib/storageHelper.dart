import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'dart:io';

import 'package:video_compress/video_compress.dart';

Future<void> uploadFile(File file) async {

  MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false, // It's false by default
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
