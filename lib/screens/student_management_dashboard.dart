import 'package:flutter/material.dart';
import 'package:student_result_app/components/dashboard_title.dart';
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
  // String _getInitials(String name) {
  //   final words = name.split(' ');
  //   String initials = '';
  //   for (var word in words) {
  //     if (word.isNotEmpty) {
  //       initials += word[0].toUpperCase(); // Take the first letter of each word
  //     }
  //   }
  //   return initials.length > 2
  //       ? initials.substring(0, 2)
  //       : initials; // Limit to 2 letters
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          children: [
            // Top Profile Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 16),
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
                      lecturerName
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
                        lecturerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lecturerEmail,
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
                  DashboardTile(
                    context,
                    icon: Icons.person_add_alt_1,
                    title: "Add Students",
                    buttonText: "ADD",
                    buttonColor: Colors.blue,
                    onTap: () {
                      // Navigate to Add Students Page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddStudentPage()));
                    },
                  ),
                  DashboardTile(
                    context,
                    icon: Icons.visibility_outlined,
                    title: "See All Students",
                    buttonText: "VIEW",
                    buttonColor: Colors.orange,
                    onTap: () {
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
                  DashboardTile(
                    context,
                    icon: Icons.menu_book,
                    title: "Enter Result",
                    buttonText: "ENTER",
                    buttonColor: Colors.blue,
                    onTap: () {
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
        Positioned(
          top: 16, // Adjust position above the BottomNavigationBar
          left: 16,
          child: Image.asset(
            'assets/images/Limkokwing_Large_Banner_Logo.jpg', // Path to your logo image
            width: 120, // Adjust the size of the logo
            height: 100,
          ),
        ),
      ]),

      // Bottom Navigation Bar
      // Bottom Navigation Bar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shadow Container
          Container(
            height: 10, // Height of the shadow space
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  offset: const Offset(0, 10), // Offset upward
                  blurRadius: 8, // Shadow blur
                ),
              ],
            ),
          ),
          // Actual BottomNavigationBar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              iconSize: 35,
              fixedColor: Colors.black,
              currentIndex: 1,
              onTap: (index) {
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
                  icon: Icon(Icons.dashboard_rounded),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
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
