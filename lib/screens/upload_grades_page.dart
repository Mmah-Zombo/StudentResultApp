import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:student_result_app/data/db/database_helper.dart';

class UploadGradesPage extends StatefulWidget {
  const UploadGradesPage({Key? key}) : super(key: key);

  @override
  _UploadGradesPageState createState() => _UploadGradesPageState();
}

class _UploadGradesPageState extends State<UploadGradesPage> {
  final _moduleNameController = TextEditingController();
  final _classNameController = TextEditingController();
  File? _selectedFile;
  final _formKey = GlobalKey<FormState>();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Only allow Excel files
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

  void _uploadGrades() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an Excel file.')),
        );
        return;
      }

      try {
        final bytes = _selectedFile!.readAsBytesSync();
        final excel = Excel.decodeBytes(bytes);

        final dbHelper = DatabaseHelper();
        final moduleName = _moduleNameController.text.trim();
        final className = _classNameController.text.trim();

        // Parse the first sheet of the Excel file
        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table]!;
          for (int i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];
            final studentName = row[0]?.value?.toString();
            final studentId = row[1]?.value?.toString();
            final grade = row[2]?.value?.toString();

            if (studentId != null && grade != null) {
              // Insert the result into the database
              await dbHelper.insertResult(
                studentId,
                moduleName,
                grade,
              );
            }
          }
          break; // Only process the first sheet
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grades uploaded successfully.')),
        );

        // Clear form after successful upload
        _moduleNameController.clear();
        _classNameController.clear();
        setState(() {
          _selectedFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Upload Grades', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter the module name, class name, and upload the Excel file containing the grades.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Module Name Input
              TextFormField(
                controller: _moduleNameController,
                decoration: const InputDecoration(
                  labelText: 'Module Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the module name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Class Name Input
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(
                  labelText: 'Class Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the class name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // File Picker
              InkWell(
                onTap: _pickFile,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFile != null
                            ? _selectedFile!.path.split('/').last
                            : 'Excel File With Grades',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.attach_file),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Upload Grades Button
              Center(
                child: ElevatedButton(
                  onPressed: _uploadGrades,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Upload Grades',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.upload_file),
      //       label: "Upload",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}
