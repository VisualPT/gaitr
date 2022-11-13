import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

///Input string is in format MM/DD/YYYY , returns a DateTime instance
stringToDateTime(String birthdate) {
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

String uint8ListTob64(Uint8List uint8list) {
  String base64String = base64Encode(uint8list);
  String header = 'data:application/pdf;base64,';
  return header + base64String;
}
