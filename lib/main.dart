import 'package:flutter/material.dart';
import 'package:student_result_app/screens/login_screen.dart';
import 'package:student_result_app/data/db/database_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  // await DatabaseHelper().deleteDatabaseFile(); // Delete the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login & Signup',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // This defines the default screen
    );
  }
}
