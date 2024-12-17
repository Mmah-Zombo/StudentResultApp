import 'package:flutter/material.dart';
import 'package:student_result_app/screens/student_profile_page.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String studentId;
  final Future<Map<String, dynamic>?> Function(String) getStudentById;

  const StudentCard({
    Key? key,
    required this.name,
    required this.studentId,
    required this.getStudentById,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shadowColor: Colors.white,
      color: const Color.fromARGB(255, 241, 241, 241),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: ListTile(
            title: Text(name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            subtitle: Text(
              studentId,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _buildStudentProfilePage(context),
                ),
              );
            },
          )),
    );
  }

  Widget _buildStudentProfilePage(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getStudentById(studentId), // Fetch student data by ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return const Center(child: Text("No data available"));
        } else {
          final student = snapshot.data!;
          return StudentProfilePage(
            studentName: student['name'],
            studentId: student['studentId'].toString(),
            studentClass: student['class'],
          );
        }
      },
    );
  }
}
