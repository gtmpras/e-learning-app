import 'package:e_learning/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
        
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){

              auth.sendPasswordResetEmail(email: _emailController.text.toString()).then((onValue){
                showToast(message: "We have sent you email to recover password, please check it!.");
              }).onError((error, stackTrace) {
                showToast(message: "incorrect email.");
              },);
            }, child: Text("Forgot"))
          ],
        ),
      ),
    );
  }
}