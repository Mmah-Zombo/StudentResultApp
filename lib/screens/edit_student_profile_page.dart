// import 'package:flutter/material.dart';
// import 'package:student_result_app/data/db/database_helper.dart';

// class EditStudentProfilePage extends StatefulWidget {
//   final String studentId; // The ID of the student to edit

//   const EditStudentProfilePage({
//     Key? key,
//     required this.studentId,
//   }) : super(key: key);

//   @override
//   _EditStudentProfilePageState createState() => _EditStudentProfilePageState();
// }

// class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _idController = TextEditingController();
//   final _classController = TextEditingController();
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();

//   final _dbHelper = DatabaseHelper();

//   @override
//   void initState() {
//     super.initState();
//     _loadStudentData(); // Load student data when the page loads
//   }

//   Future<void> _loadStudentData() async {
//     // Fetch student data by ID
//     final student = await _dbHelper.getStudentById(widget.studentId);
//     if (student != null) {
//       setState(() {
//         _nameController.text = student['name'];
//         _idController.text = student['studentId'];
//         _classController.text = student['class'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load student data')),
//       );
//     }
//   }

//   Future<void> _updateStudentProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Update the student profile in the database
//         await _dbHelper.updateStudentProfile(
//           studentId: widget.studentId,
//           name: _nameController.text.trim(),
//           classCode: _classController.text.trim(),
//           currentPassword: _currentPasswordController.text.trim(),
//           newPassword: _newPasswordController.text.trim(),
//         );

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Student profile updated successfully')),
//         );

//         // Navigate back to the previous page
//         Navigator.of(context).pop();
//       } catch (e) {
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           'Edit Student Profile',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Profile Avatar
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.black,
//                 child: Text(
//                   _nameController.text.isNotEmpty
//                       ? _nameController.text
//                           .split(" ")
//                           .map((e) => e[0])
//                           .join()
//                           .toUpperCase()
//                       : "",
//                   style: const TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Name Field
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the student name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),

//               // Student ID Field (Non-editable)
//               TextFormField(
//                 controller: _idController,
//                 readOnly: true,
//                 decoration: const InputDecoration(labelText: 'Student ID'),
//               ),
//               const SizedBox(height: 10),

//               // Class Field
//               TextFormField(
//                 controller: _classController,
//                 decoration: const InputDecoration(labelText: 'Class Code'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the class code';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),

//               // Current Password Field
//               TextFormField(
//                 controller: _currentPasswordController,
//                 decoration: const InputDecoration(labelText: 'Current Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the current password';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),

//               // New Password Field
//               TextFormField(
//                 controller: _newPasswordController,
//                 decoration: const InputDecoration(labelText: 'New Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the new password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Update Button
//               ElevatedButton(
//                 onPressed: _updateStudentProfile,
//                 style: ElevatedButton.styleFrom(
                 