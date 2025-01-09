import 'package:e_learning/screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Calling the function when the button is pressed
            await _signOut(context);  
          },
          child: Text("SignOut"),
        ),
      ),
    );
  }

  // Sign out method
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();  // Sign out from Firebase
      // Navigating to SignInScreen after sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
