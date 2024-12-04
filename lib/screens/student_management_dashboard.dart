import 'package:flutter/material.dart';
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
    final initials = _getInitials(lecturerName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            // Circle Avatar with Lecturer's Initials
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Lecturer's Name
            Expanded(
              child: Text(
                "Hi, $lecturerName",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis, // Handle long names gracefully
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Find student by ID",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[850],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // Add search logic
                  },
                ),
              ],
            ),
          ),

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
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation logic
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
