class PatientData {
  late String managingtherapistEmail = 'sample@example.com';
  late String firstname = 'sample';
  late String lastname = 'patient';
  late String bday = '01/01/1901';
  late bool isMale = true;
  late String age = '0';
  late String date = '01/01/1901';
  late String time = '00:00';
  late String velocity = "1.0";
  late double measurementDuration = 0.0;
  late bool isVideo = true;
  late String rawReportData = 'sample';
}

PatientData patientData = PatientData();

class AgeGenderNorms {
  AgeGenderNorms._();
  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const maleVelocity = [
    1.19,
    1.2,
    1.4,
    1.48,
    1.48,
    1.4,
    1.39,
    1.34,
    1.1
  ];
  static const femaleVelocity = [
    1.14,
    1.2,
    1.4,
    1.48,
    1.48,
    1.4,
    1.39,
    1.34,
    1.0
  ];

  static double _getVelocityFromAge(bool isMale, int age) {
    final int index = (age / 10).round().clamp(0, 8);
    return isMale ? maleVelocity[index] : femaleVelocity[index];
  }

  static double getPercentDifferenceFromNorm(
      double patientVelocity, bool isMale, int age) {
    final double normVelocity = _getVelocityFromAge(isMale, age);
    return (((patientVelocity - normVelocity) /
                ((patientVelocity + normVelocity) / 2)) *
            100)
        .roundToDouble();
  }
}
