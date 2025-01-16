import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_content_page.dart';
import '../pages/folder_page.dart';
import '../pages/exit_page.dart';
import '../pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 


  //fetch username from firestore
   Future<String> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc['username'] ?? 'User'; // Return username else 'User' if not it is not found.
    }
    return 'User';
  }
  // List of pages for the bottom navigation
  static List<Widget> _pages = <Widget>[
    HomeContentPage(), // Home content (the existing home body )
    SearchPage(), // Search page
    FoldersPage(), // Folders page
    ExitPage(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: FutureBuilder<String>(
          future: _getUsername(),
         builder: (context,snapshot){ if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Hello...', style: TextStyle(color: Colors.black));
            }
            return Text(
              'Hello, ${snapshot.data}',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            );
          },
        ),
      
        actions: [
          IconButton(
            icon: Icon(Icons.face, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
     
      body: _pages[_selectedIndex], // Display the selected page

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the selected index
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.door_sliding),
            label: 'Exit',
          ),
        ],
      ),
    );
  }
}

// NoteCard widget
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
          onPressed: () {
            
            print('Notes tapped');
          },
          child: Text('View'),
        ),
      ),
    );
  }
}
