// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import '../components/shared_data.dart';
import 'forgot_page.dart';
import 'signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'stats_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _navigate() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ForgotPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          // Use the FadeTransition to add the fade animation
          final tween = Tween(begin: begin, end: end);
          final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _login() async {
  try {
    // Replace 'YOUR_API_URL' with the actual URL of your Express.js login API
    const apiUrl = '${SharedData.url}/api/login';

    String email = emailController.text.trim();
    String password = passwordController.text;
    SharedData.userEmail = email;

    // Create a JSON request body with the email and password
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // Make the POST request to the API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    // Handle the API response
    if (response.statusCode == 200) {
      // Parse the response body to get the token
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['token'];
      Map<String, dynamic> userData = responseBody['userData'];

      // Save the token and _id to the SharedData class
      SharedData.userToken = token;
      SharedData.userData = userData;

      // Navigate to the StatsPage
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => StatsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            // Use the FadeTransition to add the fade animation
            final tween = Tween(begin: begin, end: end);
            final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      // Login failed
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      // Now you can access individual properties in the response body
      String message = responseBody['message'];

      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message',
            style: TextStyle(color: Colors.white), // Set the text color to white
          ),
          backgroundColor: Colors.red, //
          behavior: SnackBarBehavior.floating, // Set the behavior to top
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  } catch (e) {
    // Handle any exceptions or errors that occurred during the API request
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffFEFDF5),
      body: Column(
        children: [
          SizedBox(height: 55,),
          Container(
            width: width,
            height: height * 0.25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/buccee.png"
                ),
                // fit: BoxFit.cover,
              )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Howdy!",
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Sign on in buddy!",
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 43, 43, 43),
                  ),
                ),
                const SizedBox(height: 25,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ]
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xffEEC911),),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 25,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: Offset(1, 1),
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ]
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true, // This will hide the password text
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xffEEC911),),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                    onPressed: _navigate,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ],
                ),
                
                GestureDetector(
                  onTap: () {
                    _login();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Color(0xFFD03957),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * .08,),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Not a buddy yet?",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 43, 43, 43),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .01,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = 0.0;
                          const end = 1.0;
                          const curve = Curves.ease;

                          // Use the FadeTransition to add the fade animation
                          final tween = Tween(begin: begin, end: end);
                          final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Color(0xff6D4025),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up Here!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}