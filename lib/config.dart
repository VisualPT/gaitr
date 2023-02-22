import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

Future<void> configureAmplify() async {
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 _storagePlugin = AmplifyStorageS3();
  try {
    await Amplify.addPlugins(
        [_dataStorePlugin, _apiPlugin, _authPlugin, _storagePlugin]);
    await Amplify.configure(amplifyconfig); //Removed Cloud Services
  } catch (e) {
    log('An error occurred while configuring Amplify: $e');
  }
}
