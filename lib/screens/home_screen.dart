import 'package:flutter/material.dart';
import '../pages/home_content_page.dart';
import '../pages/folder_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track selected bottom navigation item

  // List of pages for the bottom navigation
  static List<Widget> _pages = <Widget>[
    HomeContentPage(), // Home content (the existing home body)
    FoldersPage(), // Folders page
    SearchPage(), // Search page
    ProfilePage(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, Prasoon!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Poppins-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Profile'),
              onTap: () {},
            ),
          ],
        ),
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
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
