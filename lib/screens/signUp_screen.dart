import 'package:e_learning/screens/signIn_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Checkbox state
  bool _isChecked = false;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          'Create Account',
        ),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.all(height * .02),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 30, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Create Account',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
                SizedBox(height: height*.09,),
                const Text(
                  'Name',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                    height: 20), // Space between email and password fields
                const Text(
                  'Email address',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
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
                Row(
                  children: [
                    Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        }),
                    const Text(
                      'I agree to the terms and conditions',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .03,
                ),
                ElevatedButton(
                  onPressed: _isChecked
                      ? () {
                          //signUP function
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          print("Email: $email, password: $password, name:$name");
                        }
                      : null, // Disable button if checkbox is not checked
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, 40),
                      backgroundColor: Colors.blue),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?  '),
                    GestureDetector(
                      onTap: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>SignInScreen())),
                      child: Text('Sign in',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
