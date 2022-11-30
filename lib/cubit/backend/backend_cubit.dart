import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
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

part 'backend_state.dart';

class BackendCubit extends Cubit<BackendState> {
  BackendCubit() : super(const BackendLoading());

  Future<void> init() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      emit(const BackendError("No Network Detected"));
    } else {
      try {
        final AmplifyDataStore _dataStorePlugin =
            AmplifyDataStore(modelProvider: ModelProvider.instance);
        final AmplifyAPI _apiPlugin = AmplifyAPI();
        final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
        final AmplifyStorageS3 _storagePlugin = AmplifyStorageS3();

        await Amplify.addPlugins(
            [_dataStorePlugin, _apiPlugin, _authPlugin, _storagePlugin]);
        await Amplify.configure(amplifyconfig).then((value) {
          kDebugMode ? _verboseLogging() : null;
          Amplify.Auth.fetchAuthSession().then(((session) {
            configProd();
            emit(const BackendConnected());
          }));
        });
      } on AmplifyAlreadyConfiguredException {
        emit(const BackendError(
            'Reset Gaitr to refresh the back end services.'));
      } on Exception catch (e) {
        log(e.toString());
        emit(BackendError(e.toString()));
      }
      emit(const BackendConnected());
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
        emit(const BackendConnected());
      }
    });
  }

  void _verboseLogging() {
    Amplify.Hub.listen(([HubChannel.DataStore, HubChannel.Auth]), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}", name: "Amplify");
    });
  }
}
