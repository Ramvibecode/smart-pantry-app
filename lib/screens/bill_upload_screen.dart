import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BillUploadScreen extends StatefulWidget {
  const BillUploadScreen({super.key});

  @override
  State<BillUploadScreen> createState() => _BillUploadScreenState();
}

class _BillUploadScreenState extends State<BillUploadScreen> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) 
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.file(_image!, height: 300),
                )
              else 
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.grey.shade200, style: BorderStyle.none),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text("Upload Grocery Receipt", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                      const Text("We'll audit the prices automatically", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Scan New Receipt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (_image != null) ...[
                const SizedBox(height: 12),
                TextButton(onPressed: () => setState(() => _image = null), child: const Text("Cancel")),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
