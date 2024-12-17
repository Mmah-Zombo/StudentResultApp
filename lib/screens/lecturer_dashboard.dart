import 'package:flutter/material.dart';
import 'package:student_result_app/components/dashboard_title.dart';
import 'package:student_result_app/screens/lecturer_profile_page.dart';
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Profile Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 70, horizontal: 16),
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

              // Dashboard Menu Buttons
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    DashboardTile(
                      context,
                      icon: Icons.groups_outlined,
                      title: "Manage Students",
                      onTap: () {
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
                    DashboardTile(
                      context,
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () async {
                        await _logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom-left Logo
          Positioned(
            top: 16, // Adjust position above the BottomNavigationBar
            left: 16,
            child: Image.asset(
              'assets/images/Limkokwing_Large_Banner_Logo.jpg', // Path to your logo image
              width: 120, // Adjust the size of the logo
              height: 100,
            ),
          ),
        ],
      ),

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
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StudentManagementPage(
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

  Future<void> _logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
