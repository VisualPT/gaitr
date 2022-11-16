import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/models/patient_data.dart';

abstract class AuthState {}

class Unauth extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFail extends AuthState {
  final Exception exception;

  AuthFail({required this.exception});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Unauth());

  void authUser() async {
    if (state is AuthSuccess == false) {
      emit(Unauth());
    }
    try {
      await Amplify.Auth.fetchUserAttributes().then((attributes) {
        for (AuthUserAttribute attr in attributes) {
          if (attr.userAttributeKey.toString().compareTo("email") == 0) {
            patientData.managingtherapistEmail = attr.value;
            emit(AuthSuccess());
          }
        }
      });
    } catch (e) {
      emit(AuthFail(exception: Exception(e)));
    }
  }
}
