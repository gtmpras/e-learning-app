
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FoldersPage extends StatefulWidget {
  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  // Cloudinary credentials
  final String cloudName = 'dvkagmf8y';
  final String uploadPreset = 'my_upload_preset'; // Ensure this matches the preset on Cloudinary

  // Firebase Firestore instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadPdf() async {
    // Pick a PDF file
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile == null) {
      print("No file selected.");
      return;
    }

    File file = File(pickedFile.files.single.path!);
    log("Picked file: $file");

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

    // Create a POST request with the file and other Cloudinary parameters
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: pickedFile.files.single.name,
      ));

    try {
      // Send the request to Cloudinary
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        final downloadUrl = jsonData['secure_url'];
        print("File uploaded to Cloudinary successfully: $downloadUrl");

        // Save the PDF name and URL to Firestore
        await _firebaseFirestore.collection("pdfs").add({
          "name": pickedFile.files.single.name,
          "url": downloadUrl,
        });
        print("PDF URL saved to Firestore successfully.");
      } else {
        print("Failed to upload PDF to Cloudinary. Response: $responseData");
      }
    } catch (e) {
      print("Error uploading PDF to Cloudinary: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Files"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection("pdfs").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No PDFs uploaded."));
          }

          final pdfs = snapshot.data!.docs;

          return GridView.builder(
            itemCount: pdfs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              final pdfName = pdf["name"];
              final pdfUrl = pdf["url"];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Open the PDF URL
                    // You can use a package like `url_launcher` to open the URL in a browser
                    print("Tapped on PDF: $pdfUrl");
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "images/pdf_logo.png",
                          height: 120,
                          width: 100,
                        ),
                        Text(
                          pdfName,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: uploadPdf,
      ),
    );
  }
}
