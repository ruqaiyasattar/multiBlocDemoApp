import 'package:firebase_core/firebase_core.dart';
import 'package:multiproviderbloctesting/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:multiproviderbloctesting/views/app.dart';
import 'firebase_options.dart';

void main() async {
  //ensure flutter app run before run function
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     const App(),
  );
}
