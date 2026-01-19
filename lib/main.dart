import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
// import 'core/config/flavor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Optional: Set flavor for white-label configuration
  // FlavorConfig(FlavorType.restaurant1);

  runApp(const MyApp());
}
