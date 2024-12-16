// import 'package:flutter/material.dart';

// class TextInputField extends StatelessWidget {
//   final String name;

//   const TextInputField(String name, {super.key}) {
//     this.name = name
//   };

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: _emailController,
//       decoration: InputDecoration(
//           label: const Text(
//             "Email",
//             style: TextStyle(
//               backgroundColor: Color.fromARGB(255, 248, 248, 248),
//             ),
//           ),
//           floatingLabelStyle: const TextStyle(
//             backgroundColor: Color.fromARGB(255, 248, 248, 248),
//             color: Colors.black, // Prevent color change on focus
//           ),
//           filled: true,
//           fillColor: const Color.fromARGB(255, 248, 248, 248),
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//                 color: Color.fromARGB(255, 248, 248, 248), width: 1.0),
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//                 color: Color.fromARGB(255, 51, 51, 51), width: 1.0),
//             borderRadius: BorderRadius.circular(12.0),
//           )),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your email';
//         }
//         return null;
//       },
//     );
//   }
// }
