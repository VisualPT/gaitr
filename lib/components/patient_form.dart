import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:gaitr/models/patient_data.dart';
import 'package:gaitr/data_helper.dart';

class PatientForm extends StatefulWidget {
  const PatientForm(bool isVideo, {Key? key}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  late String measurementRoute = '/video';

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: CupertinoColors.link,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: patientData.isVideo
                  ? const Icon(CupertinoIcons.video_camera)
                  : const Icon(CupertinoIcons.stopwatch),
            ),
            const Text("New Patient"),
          ],
        ),
        onPressed: formDialog);
  }

  Future<void> formDialog() {
    return showCupertinoModalPopup(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Patient Information'),
        content: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Fill out these fields to personalize the gait report"),
                const Spacer(),
                _formInput("First Name"),
                _formInput("Last Name"),
                //TODO autofill the slashes for date
                _formInput("Birth Date",
                    validationRegex:
                        r'^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$',
                    hintTextExample: "MM/DD/YYYY"),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
              color: CupertinoColors.link,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/measurement",
                      arguments: patientData.isVideo);
                }
              },
              child: const Text("Begin Evaluation"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formInput(String field,
      {int lines = 1,
      TextInputType inputType = TextInputType.text,
      String validationRegex = r'[A-Z]',
      String hintTextExample = " "}) {
    String hintText = hintTextExample.contains(" ")
        ? 'Enter a ${field.split(' ')[1].toLowerCase()}'
        : hintTextExample;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: CupertinoTextFormFieldRow(
          prefix: Text(field,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: CupertinoColors.label)),
          keyboardType: inputType,
          maxLines: lines,
          textCapitalization: TextCapitalization.words,
          placeholder: hintText,
          placeholderStyle: const TextStyle(
              fontWeight: FontWeight.w200, color: CupertinoColors.black),
          style: const TextStyle(
              fontWeight: FontWeight.w400, color: CupertinoColors.black),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter a valid response'
              : value.contains(RegExp(validationRegex))
                  ? null
                  : 'Please enter a valid response',
          onSaved: (String? value) {
            storeValue(field, value);
          },
        ),
      ),
    );
  }
}

void storeValue(String field, String? value) {
  try {
    switch (field) {
      case "First Name":
        patientData.firstname = value!;
        break;
      case "Last Name":
        patientData.lastname = value!;
        break;
      case "Birth Date":
        final DateTime birthdate = stringToDateTime(value!);
        patientData.bday = birthdate.toString().split(" ")[0];
        final now = DateTime.now();
        final String age =
            (now.difference(birthdate).inDays / 365).floor().toString();
        patientData.age = age;
        final nowString = now.toString();
        final String nowDate = nowString.split(" ")[0];
        final String nowTime = nowString.split(" ")[1].split(".")[0].substring(
            0, nowString.split(" ")[1].split(".")[0].lastIndexOf(':'));
        patientData.date = nowDate;
        patientData.time = nowTime;
        break;
      default:
        throw Exception("Invalid field or value used");
    }
  } catch (e) {
    log(e.toString());
  }
}
