import 'package:flutter/material.dart';
import 'package:student_result_app/data/db/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _classController =
      TextEditingController(); // Controller for student class
  String _role = 'Student'; // Default role

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final role = _role;
      final studentClass =
          _role == 'Student' ? _classController.text.trim() : 'N/A';

      final dbHelper = DatabaseHelper();

      try {
        // Attempt to register the user
        await dbHelper.registerUser(name, email, password, role, studentClass);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration successful! Please login.')),
        );

        // Navigate back to the login screen
        Navigator.pop(context);
      } catch (e) {
        // Handle "Email already registered" error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Role Dropdown
              DropdownButtonFormField(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'Student', child: Text('Student')),
                  DropdownMenuItem(value: 'Lecturer', child: Text('Lecturer')),
                ],
                onChanged: (value) {
                  setState(() {
                    _role = value as String;
                    if (_role == 'Lecturer') {
                      _classController
                          .clear(); // Clear class input for lecturers
                    }
                  });
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 10),

              // Class Input Field (Visible only for Students)
              if (_role == 'Student')
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(
                      labelText: 'Class Code (e.g., BSEM 1102)'),
                  validator: (value) {
                    if (_role == 'Student' &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter your class code';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: _register,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
