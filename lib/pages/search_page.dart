import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfs = [];
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPdfs();
  }

  // Fetch PDFs from Firestore and sort them by name
  Future<void> fetchPdfs() async {
    final snapshot = await _firebaseFirestore.collection("pdfs").get();
    final documents = snapshot.docs
        .map((doc) => {"name": doc["name"], "url": doc["url"]})
        .toList();

    documents.sort((a, b) => a["name"].compareTo(b["name"]));

    setState(() {
      pdfs = documents;
      searchResults = documents; // Initially show all PDFs
    });
  }

  // Binary Search Algorithm
  List<Map<String, dynamic>> binarySearch(String query) {
    int left = 0;
    int right = pdfs.length - 1;
    List<Map<String, dynamic>> results = [];

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;
      String midName = pdfs[mid]["name"].toLowerCase();

      if (midName.contains(query.toLowerCase())) {
        results.add(pdfs[mid]);

        // Look for more matches around the mid index
        int tempMid = mid;
        while (--tempMid >= 0 && pdfs[tempMid]["name"].toLowerCase().contains(query.toLowerCase())) {
          results.add(pdfs[tempMid]);
        }

        tempMid = mid;
        while (++tempMid < pdfs.length && pdfs[tempMid]["name"].toLowerCase().contains(query.toLowerCase())) {
          results.add(pdfs[tempMid]);
        }

        break;
      } else if (midName.compareTo(query.toLowerCase()) < 0) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return results;
  }

  // Perform search when user enters a query
  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = pdfs; // Show all PDFs if the query is empty
      });
      return;
    }

    final results = binarySearch(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Files'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search PDF Files',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: performSearch,
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(child: Text('No matching PDFs found.'))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final pdf = searchResults[index];
                      return ListTile(
                        leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                        title: Text(pdf["name"]),
                        onTap: () {
                          // Navigate to PDF Viewer when a search result is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(pdfUrl: pdf["url"]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
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

  void initializePdf() async {
    try {
      document = await PDFDocument.fromURL(widget.pdfUrl);
      setState(() {});
    } catch (e) {
      print('Error loading PDF: $e');
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
          : Center(child: CircularProgressIndicator()),
    );
  }
}
