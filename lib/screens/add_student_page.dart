import 'package:flutter/material.dart';
import 'package:student_result_app/components/text_input_field.dart';
import 'package:student_result_app/data/db/database_helper.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _classController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  void _addStudent() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final studentId = _studentIdController.text.trim();
      final email = _emailController.text.trim();
      final studentClass = _classController.text.trim();
      final password = _passwordController.text.trim();

      final dbHelper = DatabaseHelper();

      try {
        // Register the student
        await dbHelper.registerUser(
          name,
          email,
          password,
          "Student", // Role is "Student"
          studentClass,
          studentId,
        );

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully!')),
        );

        // Clear the form
        _formKey.currentState?.reset();
        _nameController.clear();
        _studentIdController.clear();
        _classController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _emailController.clear();
      } catch (e) {
        // Handle duplicate or other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Add New Student'),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 25),
              children: [
                Image.asset('assets/images/Limkokwing_Large_Banner_Logo.jpg',
                    height: 90),
                const SizedBox(height: 20),
                // Student Name
                CustomTextInputField(
                  controller: _nameController,
                  label: 'Student Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the student\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Student ID
                CustomTextInputField(
                  controller: _studentIdController,
                  label: 'Student ID',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the student\'s ID';
                    }
                    if (value.length != 9) {
                      return 'Student ID must be 9 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Email
                CustomTextInputField(
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Class
                CustomTextInputField(
                  controller: _classController,
                  label: 'Class',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the class';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Passcode
                CustomTextInputField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Passcode must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Confirm Passcode
                CustomTextInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm the passcode';
                    }
                    if (value != _passwordController.text) {
                      return 'Passcodes do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Add Student Button
                ElevatedButton(
                  onPressed: _addStudent,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  child: const Text(
                    'Add Student',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
