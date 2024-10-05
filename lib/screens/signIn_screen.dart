import 'package:e_learning/screens/home_screen.dart';
import 'package:e_learning/screens/signUp_screen.dart';
import 'package:e_learning/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //boolean for checking whether user is Signing in or nor?
  bool _isSigning = false;
  
  //instance of firebase Auth services
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  //controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset:
          true, // To allow the UI to resize when keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap content in a SingleChildScrollView
          child: Column(
            children: [
              Container(
                height: height * .41,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bg.png'), fit: BoxFit.cover),
                  color: Colors.blue,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Explore through your notes paradise!',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 12),
                  ),
                  const Text(
                    'Learn anything you want',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * .01),
                    width: width * .84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 30, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email address',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.black),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          SizedBox(height: height * .01),
                          ElevatedButton(
                              onPressed: () {
                                _signIn();
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width, 40),
                                  backgroundColor: Colors.blue),
                              child:_isSigning ? CircularProgressIndicator(color: Colors.white,) :const Text(
                                'Login',
                                style: TextStyle(
                                    fontFamily: 'Poppin', color: Colors.white),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignUpScreen()));
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //handle forgot password
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //signIn function with Firebase

  void _signIn() async {

    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

  setState(() {
    _isSigning = false;
  });
    if (user != null) {
      print("User is successfully Signed In");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    else{
      print("error occured during login process");
    }
  }
}
