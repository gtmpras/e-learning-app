import 'package:flutter/material.dart';

class HomeContentPage extends StatefulWidget {
  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  String selectedSubject = 'All'; // Track the selected subject

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
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Subjects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          
          //subjects selection
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
            'Popular Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          //popular notes section
          Expanded(
            child: ListView(
              children: [
                NoteCard(title: 'Probability - Maths'),
                SizedBox(height: 20,),
                NoteCard(title: 'Evolution - Science'),
                SizedBox(height: 20,),
                NoteCard(title: 'Hardware - Computer'),
              ],
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
      selected: selectedSubject == subject, // Determine if the chip is selected
      onSelected: (bool selected) {
        setState(() {
          selectedSubject = selected ? subject : selectedSubject; // Update selected subject
        });
      },
      selectedColor: Colors.blue, // Blue color when selected
      backgroundColor: Colors.grey[200], // Grey when not selected
      labelStyle: TextStyle(
        color: selectedSubject == subject ? Colors.white : Colors.black, // Change label color based on selection
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;

  NoteCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blue),
      ),
      child: ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {},
          child: Text('View'),
        ),
      ),
    );
  }
}
