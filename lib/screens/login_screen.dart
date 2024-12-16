import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              fontFamily: 'CupertinoSystemText',
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: (Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                          'assets/images/Limkokwing_Large_Banner_Logo.jpg',
                          height: 90),
                      const SizedBox(height: 10),
                      Image.asset('assets/images/student.png', height: 300),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            label: const Text(
                              "Email",
                              style: TextStyle(
                                backgroundColor:
                                    Color.fromARGB(255, 241, 241, 241),
                              ),
                            ),
                            floatingLabelStyle: const TextStyle(
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 241),
                              color:
                                  Colors.black, // Prevent color change on focus
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 241, 241),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 241, 241, 241),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 51, 51, 51),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 199, 57, 57),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 199, 57, 57),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            )),
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
                        decoration: InputDecoration(
                            label: const Text(
                              "Password",
                              style: TextStyle(
                                backgroundColor:
                                    Color.fromARGB(255, 241, 241, 241),
                              ),
                            ),
                            floatingLabelStyle: const TextStyle(
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 241),
                              color:
                                  Colors.black, // Prevent color change on focus
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 241, 241),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 241, 241, 241),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 51, 51, 51),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 199, 57, 57),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 199, 57, 57),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            )),
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
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // Rounded corners
                          ),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 120, vertical: 15.0),
                        ), // Call the login function
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
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
              ))),
        ));
  }
}
