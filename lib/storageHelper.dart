import 'dart:developer';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:video_compress/video_compress.dart';

class UserData {
  late String firstname = 'sample';
  late String lastname = 'patient';
  late String bday = '01/01/1901';
  late String age = '0';
  late String date = '01/01/1901';
  late String time = '00:00';
  late String velocity = "1.0";
  late double fallRisk = 1;
}

UserData userData = UserData();

void calculateFallRisk(double seconds) {
  double risk = (seconds - 7) / 20;
  userData.fallRisk = risk.clamp(0.1, 1.0);
}

void storeValue(String field, String? value) {
  try {
    switch (field) {
      case "First Name":
        userData.firstname = value!;
        break;
      case "Last Name":
        userData.lastname = value!;
        break;
      case "Birth Date":
        final DateTime birthdate = _stringToDateTime(value!);
        userData.bday = birthdate.toString().split(" ")[0];
        final now = DateTime.now();
        final String age =
            (now.difference(birthdate).inDays / 365).floor().toString();
        userData.age = age;
        final nowString = now.toString();
        final String nowDate = nowString.split(" ")[0];
        final String nowTime = nowString.split(" ")[1].split(".")[0].substring(
            0, nowString.split(" ")[1].split(".")[0].lastIndexOf(':'));
        userData.date = nowDate;
        userData.time = nowTime;
        break;
      default:
        throw Exception("Invalid field or value used");
    }
  } catch (e) {
    log(e.toString());
  }
}

///Input string is in format MM/DD/YYYY , returns a DateTime instance
_stringToDateTime(String birthdate) {
  try {
    final int year = int.parse(
        birthdate.substring(birthdate.lastIndexOf('/') + 1, birthdate.length));
    final int month = int.parse(birthdate.substring(
        birthdate.indexOf('/') + 1, birthdate.lastIndexOf('/')));
    final int day = int.parse(birthdate.substring(0, birthdate.indexOf('/')));
    return DateTime(year, month, day);
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
          log("Fraction completed: " +
              progress.getFractionCompleted().toString());
        });
    log('Successfully uploaded file: ${result.key}');
  } on StorageException catch (e) {
    log('Error uploading file: $e');
  }
}
