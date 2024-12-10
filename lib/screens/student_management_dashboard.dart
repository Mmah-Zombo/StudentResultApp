import 'package:flutter/material.dart';
import 'package:student_result_app/screens/add_student_page.dart';
import 'package:student_result_app/screens/lecturer_dashboard.dart';
import 'package:student_result_app/screens/lecturer_profile_page.dart';
import 'package:student_result_app/screens/student_list_page.dart';
import 'package:student_result_app/screens/upload_grades_page.dart';

class StudentManagementPage extends StatelessWidget {
  final String lecturerName; // Lecturer's full name
  final String lecturerEmail; // Lecturer's email

  const StudentManagementPage({
    Key? key,
    required this.lecturerName,
    required this.lecturerEmail,
  }) : super(key: key);

  // Helper function to get the initials of the lecturer's name
  String _getInitials(String name) {
    final words = name.split(' ');
    String initials = '';
    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase(); // Take the first letter of each word
      }
    }
    return initials.length > 2
        ? initials.substring(0, 2)
        : initials; // Limit to 2 letters
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
        elevation: 0,
        title: const Row(
          children: [
            // Lecturer's Name
            Expanded(
              child: Text(
                "S-M Dashboard",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circle Avatar with initials
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Text(
                    lecturerName
                        .split(" ")
                        .map((e) => e[0])
                        .join(), // Get initials
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Name and Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecturerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      lecturerEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Welcome Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Dashboard Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDashboardTile(
                  context,
                  icon: Icons.person_add_alt_1,
                  title: "Add Students",
                  buttonText: "ADD",
                  buttonColor: Colors.blue,
                  onPressed: () {
                    // Navigate to Add Students Page
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddStudentPage()));
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.visibility_outlined,
                  title: "See All Students",
                  buttonText: "VIEW",
                  buttonColor: Colors.orange,
                  onPressed: () {
                    // Navigate to See All Students Page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentListPage(
                          lecturerName: lecturerName,
                          lecturerEmail: lecturerEmail,
                        ),
                      ),
                    );
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.menu_book,
                  title: "Enter Result",
                  buttonText: "ENTER",
                  buttonColor: Colors.blue,
                  onPressed: () {
                    // Navigate to Enter Result Page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UploadGradesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom navigation logic
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LecturerDashboard(
                  lecturerName: lecturerName,
                  lecturerEmail: lecturerEmail,
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LecturerProfilePage(
                  lecturerName: lecturerName,
                  email: lecturerEmail,
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
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Section
            CircleAvatar(
              backgroundColor: buttonColor.withOpacity(0.2),
              radius: 25,
              child: Icon(icon, size: 30, color: buttonColor),
            ),
            const SizedBox(width: 16),
            // Title Section
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Button Section
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
