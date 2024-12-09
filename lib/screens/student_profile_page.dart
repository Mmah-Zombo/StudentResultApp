import 'package:flutter/material.dart';
import 'package:student_result_app/data/db/database_helper.dart';
import 'package:student_result_app/screens/student_list_page.dart';

class StudentProfilePage extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String studentClass;

  const StudentProfilePage({
    Key? key,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract initials from the student name
    String getInitials(String name) {
      final parts = name.split(" ");
      return parts.map((e) => e[0]).join().toUpperCase();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Student Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Text(
                getInitials(studentName),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Student Details in Cards
            _buildDetailCard("Name", studentName),
            const SizedBox(height: 10),
            _buildDetailCard("Student ID", studentId),
            const SizedBox(height: 10),
            _buildDetailCard("Class", studentClass),
            const Spacer(),

            // Buttons
            Column(
              children: [
                _buildActionButton(
                  context,
                  label: 'View Results',
                  color: Colors.black,
                  onPressed: () {
                    // Navigate to Results Page
                  },
                ),
                const SizedBox(height: 10),
                _buildActionButton(
                  context,
                  label: 'Edit Profile',
                  color: Colors.black,
                  onPressed: () {
                    // Navigate to Edit Profile Page
                  },
                ),
                const SizedBox(height: 10),
                _buildActionButton(
                  context,
                  label: 'Remove Student',
                  color: Colors.red,
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, studentId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card for displaying student details
  Widget _buildDetailCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              title == "Name"
                  ? Icons.person
                  : title == "Student ID"
                      ? Icons.badge
                      : Icons.class_,
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build an action button
  Widget _buildActionButton(BuildContext context,
      {required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.fromLTRB(70, 14, 70, 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Confirmation dialog for removing a student
  void _showDeleteConfirmationDialog(BuildContext context, studentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Student'),
          content: const Text('Are you sure you want to remove this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper();

                try {
                  // Call the deleteStudent method
                  final rowsDeleted =
                      await dbHelper.deleteStudent(studentId.toString());

                  if (rowsDeleted > 0) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Student removed successfully.')),
                    );

                    // Navigate back to the previous page
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop();
                  } else {
                    // Show error message if no student was found
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No student found with this ID.')),
                    );
                  }
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error removing student: $e')),
                  );
                }
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
