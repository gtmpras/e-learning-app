import 'package:e_learning/screens/signIn_screen.dart';
import 'package:e_learning/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isSigning = false;

  // Instance of Firebase Auth services
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _usernameController.dispose();
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
                
                Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height * .09,
                ),
                const Text(
                  'Name',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between fields
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                 
                  ),
                  obscureText: true,
                ),
               
                SizedBox(
                  height: height * .03,
                ),
                ElevatedButton(
                  onPressed: _isSigning
                      ? null
                      : () {
                          _signUp();
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width, 40),
                    backgroundColor: Colors.blue,
                  ),
                  child: _isSigning
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?  '),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SignInScreen()),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _signUp()async{
  setState(() {
    _isSigning = true;
  });

  String username = _usernameController.text;
  String email = _emailController.text;
  String password = _passwordController.text;

  User? user = await _auth.signUpWithEmailAndPassword(email, password);

  if(user != null){
    await _auth.saveUserDetails(user.uid, username, email);

    setState(() {
      _isSigning = false;
    });

    print("User is successfully created");
    Navigator.push(context, 
    MaterialPageRoute(builder: (context)=>SignInScreen()),
    );
  }else{
    setState(() {
      _isSigning = false;
    });
    print("Sign-up failed");
  }
}
}
//   // signUp function with Firebase
//   void _signUp() async {
//     setState(() {
//       _isSigning = true;
//     });

//     String email = _emailController.text;
//     String password = _passwordController.text;

//     User? user = await _auth.signUpWithEmailAndPassword(email, password);

//     setState(() {
//       _isSigning = false;
//     });

//     if (user != null) {
//       print("User is successfully created");
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignInScreen()),
//       );
//     }
//   }
// }

