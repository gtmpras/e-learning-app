
import 'package:e_learning/screens/home_screen.dart';
import 'package:e_learning/screens/signUp_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //TextEditingControllers for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    //Dispose controllers when the widget is removed from the widget tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //media queries
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: height * .41,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bg.png'), // Your image asset
                      fit: BoxFit.cover),
                  color: Colors.blue, // Background color overlay
                ),
              ),
              Expanded(
                child: Column(
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
                      margin: EdgeInsets.only(top: height* .01),
                      height: height * .48,
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            const SizedBox(
                                height:
                                    20), // Space between email and password fields
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
                            SizedBox(height: height*.01,),
                            ElevatedButton(
                                onPressed: () {
                                  //signUP function
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  print("Email: $email, password: $password");
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(width, 40),
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontFamily: 'Poppin',
                                      color: Colors.white),
                                )),
                             Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      //Handle sign-up action
                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUpScreen()));
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
