import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FoldersPage extends StatefulWidget {
  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  //instance for firebase firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //for uploading pdf part
  Future<String> uploadPdf(String fileName, File file) async {
    final refrence = FirebaseStorage.instance.ref().child(
        "pdfs/$fileName.pdf"); //defining the path where the file is stored

    final uploadTask = refrence.putFile(file);

    await uploadTask.whenComplete(() {});

    final downloadLink = await refrence.getDownloadURL();

    return downloadLink;
  }

  //for file picking
  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      uploadPdf(fileName, file);

      final downloadLink = await uploadPdf(fileName, file);

      //for storing pdf into the collection
      await _firebaseFirestore
          .collection("pdfs")
          .add({"name": fileName, "url": downloadLink});
      print("Pdf uploaded successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Files"),
      ),
      body: GridView.builder(
          itemCount: 10,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
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
                        "Pdf Name",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_file),
           onPressed: pickFile),
    );
  }
}
