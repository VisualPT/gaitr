import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:gaitr/app_styles.dart';
import 'package:gaitr/models/patient_data.dart';

class PatientForm extends StatefulWidget {
  const PatientForm(bool isVideo, {Key? key}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: CupertinoColors.link,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              patientData.isVideo ? "Record " : "    Time ",
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
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return CupertinoAlertDialog(
          title: const Text('Patient Information'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 255,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      "Fill out these fields to personalize the gait report"),
                  _formInput("First Name"),
                  _formInput("Last Name"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Birth Date",
                              style: AppStyles.inputPromptStyle),
                          CupertinoButton(
                            onPressed: () => showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      height: 216,
                                      padding: const EdgeInsets.only(top: 6.0),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      color: CupertinoColors.systemBackground
                                          .resolveFrom(context),
                                      child: SafeArea(
                                        top: false,
                                        child: CupertinoDatePicker(
                                          initialDateTime: date,
                                          mode: CupertinoDatePickerMode.date,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            setState(() => date = newDate);
                                          },
                                        ),
                                      ),
                                    )),
                            child:
                                Text('${date.month}/${date.day}/${date.year}'),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  storeDateTimeData(date);
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
        );
      }),
    );
  }

  Widget _formInput(String field) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: CupertinoTextFormFieldRow(
          prefix: Text(field, style: AppStyles.inputPromptStyle),
          textCapitalization: TextCapitalization.words,
          placeholder: 'Enter a ${field.split(' ')[1].toLowerCase()}',
          placeholderStyle: AppStyles.inputPlaceholderStyle,
          style: AppStyles.inputTextStyle,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter a valid response'
              : null,
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
      default:
        throw Exception("Invalid field or value used");
    }
  } catch (e) {
    log(e.toString());
  }
}

void storeDateTimeData(DateTime date) {
  patientData.bday = date.toString().split(" ")[0];
  final now = DateTime.now();
  final String age = (now.difference(date).inDays / 365).floor().toString();
  patientData.age = age;
  final nowString = now.toString();
  final String nowDate = nowString.split(" ")[0];
  final String nowTime = nowString
      .split(" ")[1]
      .split(".")[0]
      .substring(0, nowString.split(" ")[1].split(".")[0].lastIndexOf(':'));
  patientData.date = nowDate;
  patientData.time = nowTime;
}
