import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mc/firebase_options.dart';
import 'package:mc/pages/home.dart';
import 'package:mc/pages/auth/login.dart';
import 'package:mc/pages/auth/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
