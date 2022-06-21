import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> createAndUploadFile() async {
  // Create a dummy file
  final exampleString = 'Example file contents';
  final tempDir = await getTemporaryDirectory();
  final exampleFile = File(tempDir.path + '/example.txt')
    ..createSync()
    ..writeAsStringSync(exampleString);

  // Upload the file to S3
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: exampleFile,
        key: 'ExampleKey',
        onProgress: (progress) {
          print("Fraction completed: " +
              progress.getFractionCompleted().toString());
        });
    print('Successfully uploaded file: ${result.key}');
  } on StorageException catch (e) {
    print('Error uploading file: $e');
  }
}
