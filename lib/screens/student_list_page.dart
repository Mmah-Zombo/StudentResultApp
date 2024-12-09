import 'package:flutter/material.dart';
import 'package:student_result_app/data/db/database_helper.dart';
import 'package:student_result_app/screens/add_student_page.dart';
import 'package:student_result_app/screens/student_profile_page.dart';

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
            color: Colors.black,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Text(
                    widget.lecturerName
                        .split(" ")
                        .map((e) => e[0])
                        .join(), // Lecturer initials
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Hi, ${widget.lecturerName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
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
                      return _buildStudentCard(
                        student['name'],
                        student['studentId'] != null
                            ? student['studentId'].toString()
                            : 'N/A',
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
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                "Add Student",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation logic
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Students",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(String name, String studentId) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(studentId),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Handle navigation to student details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder<Map<String, dynamic>?>(
                future:
                    dbHelper.getStudentById(studentId), // Pass the student ID
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(child: Text("hii"));
                  } else {
                    final student = snapshot.data!;
                    return StudentProfilePage(
                      studentName: student['name'],
                      studentId: student['studentId'].toString(),
                      studentClass: student['class'],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
