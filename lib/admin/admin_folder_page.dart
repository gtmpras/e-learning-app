
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFolderPage extends StatefulWidget {
  @override
  State<AdminFolderPage> createState() => _AdminFolderPageState();
}

class _AdminFolderPageState extends State<AdminFolderPage> {
  // Cloudinary credentials
  final String cloudName = 'dvkagmf8y';
  final String uploadPreset = 'my_upload_preset'; // Ensure this matches the preset on Cloudinary

  // Firebase Firestore instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Uploading  PDF files  to Cloudinary and Firestore 
  Future<void> uploadPdf() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile == null) {
      print("No file selected.");
      return;
    }

    File file = File(pickedFile.files.single.path!);
    log("Picked file: ${file.path}");

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: pickedFile.files.single.name,
      ));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        final downloadUrl = jsonData['secure_url'];
        print("File uploaded to Cloudinary successfully: $downloadUrl");

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
        title: Text("Uploaded PDFs"),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
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

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  // Initialize the PDF document
  void initializePdf() async {
    try {
      document = await PDFDocument.fromURL(widget.pdfUrl);
      setState(() {});
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle the error gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: document != null
          ? PDFViewer(document: document!)
          : Center(child: CircularProgressIndicator()), // Show loading until the PDF is loaded
    );
  }
}
