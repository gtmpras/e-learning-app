
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/admin_page/admin_folder_page.dart';
import 'package:e_learning/pages/folder_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeContentPage extends StatefulWidget {
  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  String selectedSubject = 'All';
  List<String> recentNotes = []; 
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchRecentNotes();
  }

  // Fetch the most recent 5 PDF file names from Firebase
  Future<void> fetchRecentNotes() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('pdfs') 
          .limit(3)
          .get();

      List<String> notes = snapshot.docs.map((doc) {
        return doc['name'] != null ? doc['name'] as String : 'Untitled name'; 
      }).toList();

      setState(() {
        recentNotes = notes;
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What do you wanna learn today?",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          // Carousel Slider
          CarouselSlider(
            items: [
              buildImageContainer(
                  'https://images.pexels.com/photos/68761/pexels-photo-68761.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
              buildImageContainer(
                  'https://images.pexels.com/photos/17771091/pexels-photo-17771091/free-photo-of-child-using-internet.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
              buildImageContainer(
                  'https://images.pexels.com/photos/247819/pexels-photo-247819.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
            ],
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),

          SizedBox(height: 16),
          Text(
            'Subjects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Subjects selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              subjectChip('All'),
              subjectChip('Science'),
              subjectChip('Maths'),
              subjectChip('Computer'),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Your Recent Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Displaying recent updated notes
          Expanded(
            child: ListView.builder(
              itemCount: recentNotes.length,
              itemBuilder: (context, index) {
                final noteTitle = recentNotes[index];
                return Column(
                  children: [
                    NoteCard(title: noteTitle, isAdmin: isAdmin), // Pass isAdmin here
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the subject chip
  Widget subjectChip(String subject) {
    return ChoiceChip(
      label: Text(subject),
      selected: selectedSubject == subject,
      onSelected: (bool selected) {
        setState(() {
          selectedSubject = selected ? subject : selectedSubject;
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selectedSubject == subject ? Colors.white : Colors.black,
      ),
    );
  }


  Widget buildImageContainer(String imageUrl) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final bool isAdmin;

  NoteCard({required this.title, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blue),
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(Icons.notifications,color: Colors.blue,),
      ),
    );
  }
}
