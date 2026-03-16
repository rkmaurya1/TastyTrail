import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Seed initial data to Firestore if empty
  FirestoreService().seedInitialData();

  runApp(const MyApp());
}
