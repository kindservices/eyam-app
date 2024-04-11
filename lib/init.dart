import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyam_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Init {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    if (kDebugMode) {
      // Point Firestore to the Firestore emulator
      FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', // Replace with your emulator's host and port
        sslEnabled: false,
        persistenceEnabled:
            false, // Optional, set to false to ensure fresh emulator data
      );
    }
  }
}
