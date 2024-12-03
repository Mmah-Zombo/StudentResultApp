import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_result_app/screens/login_screen.dart';
import 'package:student_result_app/screens/student_result_page.dart';

class StudentDashboard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String studentClass;

  const StudentDashboard({
    Key? key,
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'Student Dashboard',
          style: TextStyle(color: Colors.white),
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
                    studentName
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
                // Name and ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      studentId,
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

          // Class Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Class: $studentClass",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Dashboard Menu Buttons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDashboardTile(
                  context,
                  icon: Icons.description_outlined,
                  title: "Results",
                  onTap: () {
                    // Navigate to Results Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentResultPage(
                          cgpa: "3.9", // Replace with actual CGPA from database
                          subjects: [
                            {
                              "title": "Digital Marketing",
                              "grade": "A+",
                              "year": "S2024"
                            },
                            {
                              "title": "Design Learning",
                              "grade": "B",
                              "year": "S2024"
                            },
                            {
                              "title": "Software Management",
                              "grade": "B+",
                              "year": "S2024"
                            },
                            {
                              "title": "Digital Logical Thoughts",
                              "grade": "C",
                              "year": "S2024"
                            },
                            {
                              "title": "Artificial Intelligence",
                              "grade": "F",
                              "year": "S2024"
                            },
                            {
                              "title": "Physics",
                              "grade": "A+",
                              "year": "S2024"
                            },
                            {
                              "title": "Mathematics",
                              "grade": "C+",
                              "year": "S2023"
                            },
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.schedule,
                  title: "Timetables",
                  onTap: () {
                    // Navigate to Timetables Page
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.attach_money_outlined,
                  title: "Fees",
                  onTap: () {
                    // Navigate to Fees Page
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    // Handle Logout
                    _logout(context); // Go back to login
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home is active
        onTap: (index) {
          // Handle navigation if multiple tabs are implemented
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Clear session data (e.g., SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login screen and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // Dashboard Tile Widget
  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
