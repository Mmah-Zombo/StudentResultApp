import 'package:flutter/material.dart';
import 'package:student_result_app/components/student_card.dart';
import 'package:student_result_app/data/db/database_helper.dart';
import 'package:student_result_app/screens/add_student_page.dart';

class StudentListPage extends StatefulWidget {
  final String lecturerName; // Name of the lecturer
  final String lecturerEmail; // Email of the lecturer

  const StudentListPage({
    Key? key,
    required this.lecturerName,
    required this.lecturerEmail,
  }) : super(key: key);

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _students = []; // Full list of students
  List<Map<String, dynamic>> _filteredStudents = []; // Filtered list for search
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchAllStudents(); // Fetch all students when the page loads
  }

  Future<void> _fetchAllStudents() async {
    final dbHelper = DatabaseHelper();

    // Fetch all students from the database
    final students = await dbHelper.getAllStudents();

    setState(() {
      _students = students; // Full list of students
      _filteredStudents = students; // Initially show all students
    });
  }

  void _filterStudents(String query) {
    final filtered = _students.where((student) {
      final studentId = student['studentId'].toString();
      final studentName = student['name'].toString().toLowerCase();
      return studentId.contains(query) ||
          studentName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredStudents = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Students",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black, // Fallback color in case the image fails
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg-image.png'), // Background image path
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.lecturerName
                        .split(" ")
                        .map((e) => e[0])
                        .join(), // Get initials
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.lecturerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.lecturerEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStudents, // Filter students as you type
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Search by student ID or name",
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Student List
          Expanded(
            child: _filteredStudents.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return StudentCard(
                        name: student['name'],
                        studentId: student['studentId'] != null
                            ? student['studentId'].toString()
                            : 'N/A',
                        getStudentById: dbHelper.getStudentById,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No students found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),

          // Add Student Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Add Student Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddStudentPage(), // Navigate to AddStudentPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
              ),
              child: const Text(
                "Add Student",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
