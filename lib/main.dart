import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot1/pages/homepage.dart';
import 'package:iot1/pages/landingpage.dart';

void main() async {
  // Ensure initialization
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "your api key",
          authDomain: "your auth domain",
          projectId: "your project id",
          storageBucket: "your storage bucket",
          messagingSenderId: "your sender id",
          appId: "your app id",
          measurementId: "your measurement id",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Specify the initial route
        routes: {
          '/': (context) => LandingPage(),
          '/home': (context) => HomePage(),}

    );
  }
}