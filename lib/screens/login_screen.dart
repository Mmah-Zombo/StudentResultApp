import 'package:flutter/material.dart';
import 'package:student_result_app/data/db/database_helper.dart'; // Import the DatabaseHelper
import 'package:student_result_app/screens/lecturer_dashboard.dart';
import 'package:student_result_app/screens/signup_screen.dart';
import 'package:student_result_app/screens/student_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final dbHelper = DatabaseHelper();
      final user = await dbHelper.loginUser(email, password);

      if (user != null && user['role'] == 'Student') {
        // Navigate to the Student Dashboard on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDashboard(
              studentName: user['name'],
              userName: user['name'],
              studentId: user['studentId'].toString(),
              studentClass: user['class'], // Replace with actual column
            ),
          ),
        );
      } else if (user != null && user['role'] == 'Lecturer') {
        // Navigate to the Student Dashboard on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LecturerDashboard(
              lecturerName: user['name'],
              lecturerEmail: user['email'],
            ),
          ),
        );
      } else {
        // Show error if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login, // Call the login function
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to SignupScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
