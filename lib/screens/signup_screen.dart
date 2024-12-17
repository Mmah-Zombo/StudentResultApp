import 'package:flutter/material.dart';
import 'package:student_result_app/components/text_input_field.dart';
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
  final _studentIdController =
      TextEditingController(); // Controller for student ID
  String _role = 'Student'; // Default role

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final role = _role;
      final studentClass =
          _role == 'Student' ? _classController.text.trim() : 'N/A';
      final studentId =
          _role == 'Student' ? _studentIdController.text.trim() : null;

      final dbHelper = DatabaseHelper();

      try {
        // Attempt to register the user
        await dbHelper.registerUser(
          name,
          email,
          password,
          role,
          studentClass,
          studentId,
        );

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
      backgroundColor: Colors.white,
      appBar:
          AppBar(title: const Text('Sign Up'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        // Enables scrolling when content overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Logo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                        'assets/images/Limkokwing_Large_Banner_Logo.jpg',
                        height: 90),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/studying-student.png',
                        height: 300),
                  ],
                ),

                const SizedBox(height: 10),

                // Full Name Field
                CustomTextInputField(
                  controller: _nameController,
                  label: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Email Field
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

                // Password Field
                CustomTextInputField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true,
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
                    DropdownMenuItem(
                        value: 'Lecturer', child: Text('Lecturer')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _role = value as String;
                      if (_role == 'Lecturer') {
                        _classController
                            .clear(); // Clear class input for lecturers
                        _studentIdController
                            .clear(); // Clear student ID input for lecturers
                      }
                    });
                  },
                  dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 241, 241, 241),
                    floatingLabelStyle: const TextStyle(
                      backgroundColor: Color.fromARGB(255, 241, 241, 241),
                      color: Colors.black, // Prevent color change on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 241, 241, 241),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 51, 51, 51),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 199, 57, 57),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 199, 57, 57),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Class Input Field (Visible only for Students)
                if (_role == 'Student')
                  CustomTextInputField(
                    controller: _classController,
                    label: 'Class Code (e.g., BSEM 1102)',
                    validator: (value) {
                      if (_role == 'Student' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter your class code';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),

                // Student ID Field (Visible only for Students)
                if (_role == 'Student')
                  CustomTextInputField(
                    controller: _studentIdController,
                    label: 'Student ID (e.g., 90500XXXX)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_role == 'Student' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter your Student ID';
                      }
                      if (_role == 'Student' && value!.length != 9) {
                        return 'Student ID must be exactly 9 digits';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),

                // Sign Up Button
                Center(
                  child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 15.0),
                      ),
                      child: const Text('Sign Up',
                          style: TextStyle(color: Colors.white))),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
