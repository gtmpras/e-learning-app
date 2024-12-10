
// import 'dart:developer';
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// class FoldersPage extends StatefulWidget {
//   @override
//   State<FoldersPage> createState() => _FoldersPageState();
// }

// class _FoldersPageState extends State<FoldersPage> {
//   // Cloudinary credentials
//   final String cloudName = 'dvkagmf8y';
//   final String uploadPreset = 'my_upload_preset'; // Ensure this matches the preset on Cloudinary

//   // Firebase Firestore instance
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Future<void> uploadPdf() async {
//     // Pick a PDF file
//     final pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (pickedFile == null) {
//       print("No file selected.");
//       return;
//     }

//     File file = File(pickedFile.files.single.path!);
//     log("Picked file: $file");

//     final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

//     // Create a POST request with the file and other Cloudinary parameters
//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = uploadPreset
//       ..files.add(await http.MultipartFile.fromPath(
//         'file',
//         file.path,
//         filename: pickedFile.files.single.name,
//       ));

//     try {
//       // Send the request to Cloudinary
//       final response = await request.send();
//       final responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(responseData);
//         final downloadUrl = jsonData['secure_url'];
//         print("File uploaded to Cloudinary successfully: $downloadUrl");

//         // Save the PDF name and URL to Firestore
//         await _firebaseFirestore.collection("pdfs").add({
//           "name": pickedFile.files.single.name,
//           "url": downloadUrl,
//         });
//         print("PDF URL saved to Firestore successfully.");
//       } else {
//         print("Failed to upload PDF to Cloudinary. Response: $responseData");
//       }
//     } catch (e) {
//       print("Error uploading PDF to Cloudinary: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firebaseFirestore.collection("pdfs").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No PDFs uploaded."));
//           }

//           final pdfs = snapshot.data!.docs;

//           return GridView.builder(
//             itemCount: pdfs.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//             itemBuilder: (context, index) {
//               final pdf = pdfs[index];
//               final pdfName = pdf["name"];
//               final pdfUrl = pdf["url"];

//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Image.asset(
//                           "images/pdf_logo.png",
//                           height: 120,
//                           width: 100,
//                         ),
//                         Text(
//                           pdfName,
//                           style: TextStyle(fontSize: 18),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.upload_file),
//         onPressed: uploadPdf,
//       ),
//     );
//   }
// }

// class PdfViewerScreen extends StatefulWidget {
//   final String pdfUrl;



//   PdfViewerScreen({required this.pdfUrl});

//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   var document ;
//   late WebViewController controller ;
//   @override
//   void initState() {
//     super.initState();

//       controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onHttpError: (HttpResponseError error) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//     ..loadRequest(Uri.parse(widget.pdfUrl));

//   // ..loadRequest(Uri.parse("https://drive.google.com/file/d/0B28Gtf1n8u8DUnF2cTliTXo2Y1E/view?resourcekey=0-pd6Q3GLnI09wt1u5EoGAAQ"));

//        ;

//         /* cacheManager: CacheManager(
//           Config(
//             "customCacheKey",
//             stalePeriod: const Duration(days: 2),
//             maxNrOfCacheObjects: 10,
//           ),
//         ), */
      
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(title: Text("PDF Viewer")),
//       body: WebViewWidget(controller: controller));
//   }
// }

// import 'dart:developer';
// import 'dart:io';
// import 'dart:convert';
// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class FoldersPage extends StatefulWidget {
//   @override
//   State<FoldersPage> createState() => _FoldersPageState();
// }

// class _FoldersPageState extends State<FoldersPage> {
//   // Cloudinary credentials
//   final String cloudName = 'dvkagmf8y';
//   final String uploadPreset = 'my_upload_preset'; // Ensure this matches the preset on Cloudinary

//   // Firebase Firestore instance
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   // Upload PDF to Cloudinary and Firestore
//   Future<void> uploadPdf() async {
//     final pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (pickedFile == null) {
//       print("No file selected.");
//       return;
//     }

//     File file = File(pickedFile.files.single.path!);
//     log("Picked file: ${file.path}");

//     final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');
//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = uploadPreset
//       ..files.add(await http.MultipartFile.fromPath(
//         'file',
//         file.path,
//         filename: pickedFile.files.single.name,
//       ));

//     try {
//       final response = await request.send();
//       final responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(responseData);
//         final downloadUrl = jsonData['secure_url'];
//         print("File uploaded to Cloudinary successfully: $downloadUrl");

//         await _firebaseFirestore.collection("pdfs").add({
//           "name": pickedFile.files.single.name,
//           "url": downloadUrl,
//         });
//         print("PDF URL saved to Firestore successfully.");
//       } else {
//         print("Failed to upload PDF to Cloudinary. Response: $responseData");
//       }
//     } catch (e) {
//       print("Error uploading PDF to Cloudinary: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Uploaded PDFs"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firebaseFirestore.collection("pdfs").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No PDFs uploaded."));
//           }

//           final pdfs = snapshot.data!.docs;

//           return GridView.builder(
//             itemCount: pdfs.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//             itemBuilder: (context, index) {
//               final pdf = pdfs[index];
//               final pdfName = pdf["name"];
//               final pdfUrl = pdf["url"];

//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
//                         Text(
//                           pdfName,
//                           style: TextStyle(fontSize: 18),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.upload_file),
//         onPressed: uploadPdf,
//       ),
//     );
//   }
// }


//**This is pdf reader code backup */
// class PdfViewerScreen extends StatelessWidget {
//   final String pdfUrl;

//   PdfViewerScreen({required this.pdfUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("PDF Viewer")),
//       body: SfPdfViewer.network(
//         pdfUrl,
//         onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to load PDF: ${details.error}'),
//               duration: Duration(seconds: 5),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class PdfViewerScreen extends StatefulWidget {
//   final String pdfurl;
//   const PdfViewerScreen({super.key, required this.pdfurl});

//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {

//   PDFDocument? document;

//   void initializePdf()async{

// document =await PDFDocument.fromURL(widget.pdfurl);
// setState(() {
  
// });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:document!= null? PDFViewer(
//         document: document!,):Center(child: CircularProgressIndicator()));

//   }
// }



import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
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

  // Upload PDF to Cloudinary and Firestore
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
