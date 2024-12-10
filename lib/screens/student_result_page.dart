import 'package:flutter/material.dart';
import 'package:student_result_app/data/db/database_helper.dart';
import 'package:student_result_app/screens/profile.dart';
import 'package:student_result_app/screens/student_dashboard.dart';

class StudentResultPage extends StatefulWidget {
  final String studentId; // Student ID to fetch results

  const StudentResultPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  _StudentResultPageState createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _cgpa = "0.0"; // Placeholder for CGPA
  List<Map<String, dynamic>> _results = []; // Placeholder for student results
  Map<String, dynamic>? _student; // Placeholder for student details

  @override
  void initState() {
    super.initState();
    _fetchStudentResults(); // Fetch data on initialization
  }

  Future<void> _fetchStudentResults() async {
    try {
      // Fetch all results for the given student ID
      final results = await _dbHelper.getResultsByStudentId(widget.studentId);
      final student = await _dbHelper.getStudentById(widget.studentId);

      setState(() {
        _results = results;
        _student = student;
      });

      // Calculate CGPA if results are present
      if (results.isNotEmpty) {
        final totalGrades = results
            .map((r) => _gradeToPoint(r['grade']))
            .reduce((a, b) => a + b);
        final cgpa = (totalGrades / results.length).toStringAsFixed(2);

        setState(() {
          _cgpa = cgpa;
        });
      } else {
        setState(() {
          _cgpa = "0.0"; // Default CGPA if no results
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching results: $e')),
      );
    }
  }

  // Convert grade to grade points for CGPA calculation
  double _gradeToPoint(String grade) {
    switch (grade.toUpperCase()) {
      case "A+":
      case "A":
      case "A-":
        return 4.0;
      case "B+":
        return 3.7;
      case "B":
        return 3.5;
      case "B-":
        return 3.0;
      case "C+":
        return 2.5;
      case "C":
        return 2.0;
      case "D":
        return 1.0;
      case "F":
        return 0.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Grades", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Header Section with CGPA
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "CGPA:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _cgpa,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // List of Subjects
          Expanded(
            child: _results.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return _buildSubjectCard(
                        context,
                        title: result['moduleName'],
                        grade: result['grade'],
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No grades found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Highlight "Results" tab
        onTap: (index) {
          if (index == 0 && _student != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentDashboard(
                  studentId: _student!["studentId"].toString(),
                  studentName: _student!["name"],
                  studentClass: _student!["class"],
                  userName: _student!["name"],
                ),
              ),
            );
          } else if (index == 2 && _student != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Profile(
                  studentId: _student!["studentId"].toString(),
                  studentName: _student!["name"],
                  studentClass: _student!["class"],
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Results",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // Card Widget for Each Subject
  Widget _buildSubjectCard(BuildContext context,
      {required String title, required String grade}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Subject Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Grade
            Text(
              grade,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
