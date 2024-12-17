import 'package:flutter/material.dart';

Widget DashboardTile(BuildContext context,
    {required IconData icon,
    required String title,
    required VoidCallback onTap,
    buttonText,
    buttonColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      shadowColor: Colors.white,
      color: const Color.fromARGB(255, 240, 250, 255),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Row(
          children: [
            Icon(icon, size: 35, color: Colors.blue),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            buttonText != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onTap,
                    child: Text(buttonText,
                        style: const TextStyle(color: Colors.white)),
                  )
                : const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.black),
          ],
        ),
      ),
    ),
  );
}
