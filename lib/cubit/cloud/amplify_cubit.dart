import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/amplifyconfiguration.dart';
import 'package:gaitr/models/ModelProvider.dart';

abstract class AmplifyState {}

class AmplifyConfigured extends AmplifyState {}

class AmplifyNotConfigured extends AmplifyState {}

class AmplifyFailure extends AmplifyState {
  final Exception exception;
  AmplifyFailure({required this.exception});
}

class AmplifyCubit extends Cubit<AmplifyState> {
  AmplifyCubit() : super(AmplifyNotConfigured());

  Future<void> init() async {
    try {
      final AmplifyDataStore _dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);
      final AmplifyAPI _apiPlugin = AmplifyAPI();
      final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
      final AmplifyStorageS3 _storagePlugin = AmplifyStorageS3();
      try {
        await Amplify.addPlugins(
            [_dataStorePlugin, _apiPlugin, _authPlugin, _storagePlugin]);
        await Amplify.configure(amplifyconfig).then((value) {
          kDebugMode ? _verboseLogging() : null;
          Amplify.Auth.fetchAuthSession().then(((session) {
            configProd();
            emit(AmplifyConfigured());
          }));
        });
      } on AmplifyAlreadyConfiguredException {
        emit(AmplifyFailure(
            exception: Exception(
                'Tried to reconfigure Amplify; this can occur when your app restarts on Android. To solve: Reset App.')));
      }
    } on Exception catch (e) {
      log(e.toString());
      emit(AmplifyFailure(exception: e));
    }
  }

  Future<void> configProd() async {
    log("Production (local storage persistant on app restart) or no user signed in",
        name: "Amplify Config Mode");
  }

  Future<void> configDev() async {
    log("Development (local storage cleared and resynced upon app restarted)",
        name: "Amplify Config Mode");
    await Amplify.DataStore.clear().then((_) => Amplify.DataStore.start());
  }

  //Delays queries until DataStore is completely synced
  void syncListener() {
    Amplify.Hub.listen(([HubChannel.DataStore]), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}");
      if (hubEvent.eventName == 'ready') {
        emit(AmplifyConfigured());
      }
    });
  }

  void _verboseLogging() {
    Amplify.Hub.listen(([HubChannel.DataStore, HubChannel.Auth]), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}", name: "Amplify");
    });
  }
}
