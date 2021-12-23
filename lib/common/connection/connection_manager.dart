import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityManager {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectivityManager _singleton = ConnectivityManager._internal();

  ConnectivityManager._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectivityManager getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  BehaviorSubject connectionChangeController = new BehaviorSubject();

  Stream get connectionChange => connectionChangeController.stream;

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    debugPrint("\n (^_^) ******************** Connectivity Closed____");
    connectionChangeController.close();
  }

  Future<ConnectivityResult> checkConnectivity() async {
    return await (_connectivity.checkConnectivity());
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      if (!connectionChangeController.isClosed)
        connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
