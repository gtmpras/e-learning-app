

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {


  FirebaseAuth _auth = FirebaseAuth.instance;


  //signUp authentication with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password)async{

    try{
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;

    }catch(e){
      print("Error occured"+e.toString());
    }
    return null;
  }



//login authentication for SignIn with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password)async{

    try{
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;

    }catch(e){
      print("Error occured"+e.toString());
    }
    return null;
  }
}