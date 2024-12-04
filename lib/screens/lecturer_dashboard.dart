import 'package:flutter/material.dart';
import 'package:student_result_app/screens/login_screen.dart';
import 'package:student_result_app/screens/student_management_dashboard.dart';

class LecturerDashboard extends StatelessWidget {
  final String lecturerName;
  final String lecturerEmail;

  const LecturerDashboard({
    Key? key,
    required this.lecturerName,
    required this.lecturerEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'Lecturer Dashboard',
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

          // Dashboard Menu Buttons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDashboardTile(
                  context,
                  icon: Icons.supervised_user_circle_outlined,
                  title: "Manage Students",
                  onTap: () {
                    // Navigate to Manage Students Page and pass lecturer data
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentManagementPage(
                          lecturerName: lecturerName,
                          lecturerEmail: lecturerEmail,
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
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () async {
                    // Call logout logic
                    await _logout(context);
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
          // Handle navigation logic
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Logout Logic
  Future<void> _logout(BuildContext context) async {
    // Add logout logic, such as clearing session data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginScreen()), // Replace with actual login screen
      (route) => false,
    );
  }
}
