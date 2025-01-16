import 'package:e_learning/admin_page/admin_folder_page.dart';
import 'package:e_learning/pages/search_page.dart';
import 'package:flutter/material.dart';
import '../pages/exit_page.dart';
import '../pages/home_content_page.dart';


class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0; // Track selected bottom navigation item

  // List of pages for the bottom navigation
  static List<Widget> _pages = <Widget>[
    HomeContentPage(),
    SearchPage(),
    AdminFolderPage(), 
    ExitPage(), 
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, Admin!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Poppins-Regular',
            fontWeight: FontWeight.bold,
          ),
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
            icon: Icon(Icons.exit_to_app),
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
