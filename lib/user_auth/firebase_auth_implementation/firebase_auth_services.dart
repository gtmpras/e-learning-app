
import 'package:e_learning/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {

  FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up authentication with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Error: email-already-in-use');
        showToast(message: 'The email address is already in use');
      } else {
        print('Error: ${e.code}');
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  // Login authentication for SignIn with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Error: Invalid email or password');
        showToast(message: 'Invalid email or password');
      } else {
        print('Error: ${e.code}');
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
