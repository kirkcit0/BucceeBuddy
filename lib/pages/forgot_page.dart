// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app_large_project/pages/login_page.dart';
import 'package:app_large_project/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/shared_data.dart';


class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController emailController = TextEditingController();

  void _navigate() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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

  void _forgot() async {
    try {
      // Replace 'YOUR_API_URL' with the actual URL of your Express.js forgot API
      const apiUrl = '${SharedData.url}/api/forgot';

      String email = emailController.text.trim();

      // Create a JSON request body with the email and password
      final Map<String, dynamic> data = {
        'email': email,
      };

      // Make the POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // Handle the API response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['message'];

        // Show a SnackBar with the error message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(color: Colors.black), // Set the text color to white
            ),
            backgroundColor: Color(0xffEEC911), //
            behavior: SnackBarBehavior.floating, // Set the behavior to top
            duration: const Duration(milliseconds: 1500),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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
        // failed
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // Now you can access individual properties in the response body
        String message = responseBody['message'];

        // Show a SnackBar with the error message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
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
              )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reset!",
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Well what's your Email, Bucco?",
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
                
                const SizedBox(height: 5,),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                    onPressed: _navigate,
                    child: Text(
                      'Remember?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 5,),

                GestureDetector(
                  onTap: () {
                    _forgot();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xFFEEC911), 
                          Color(0xFFF2D648),
                          Color(0xFFF2E691),
                          Color(0xFFFCF5D4),
                          Color(0xFFFEFDF5),
                          Color(0xFFFCF5D4),
                          Color(0xFFF2E691),
                          Color(0xFFF2D648),
                          Color(0xFFEEC911),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Send Reset Link",
                        style: TextStyle(
                          color: Colors.black,
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