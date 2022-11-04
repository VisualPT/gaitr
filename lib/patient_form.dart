import 'package:flutter/cupertino.dart';
import 'package:gaiter/storageHelper.dart';

class PatientForm extends StatefulWidget {
  const PatientForm({Key? key}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  bool useCamera = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _formInput("First Name"),
            _formInput("Last Name"),
            _formInput("Birth Date",
                validationRegex:
                    r'^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$',
                hintTextExample: "MM/DD/YYYY"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Use video-recorded measurement',
                      style:
                          TextStyle(color: CupertinoColors.systemBackground)),
                  Spacer(),
                  CupertinoSwitch(
                    value: useCamera,
                    onChanged: (bool value) {
                      setState(() {
                        useCamera = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            CupertinoButton(
              color: CupertinoColors.link,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pushNamed(context, "/measurement");
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Begin Evaluation "),
                  Icon(CupertinoIcons.forward),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(1),
        ),
        child: CupertinoTextFormFieldRow(
          prefix: Text(field),
          keyboardType: inputType,
          maxLines: lines,
          textCapitalization: TextCapitalization.words,
          placeholder: hintText,
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
