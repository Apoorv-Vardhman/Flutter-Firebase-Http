import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'common/connection/connection_manager.dart';
import 'data/api/api_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ApiManager.getInstance();
  ConnectivityManager.getInstance().initialize();
  runApp(App());
}