import 'package:flutter/material.dart';

import '../../MVVM/Service/api_service.dart';
import '../home/home_screen.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _signup(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;

      final token = await ApiService()
          .signup(email: email, password: password, name: name);

      if (token != null) {
        print('Signup successful! Token: $token');
        // Navigate to the main screen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        print('Signup failed.');
        // Optionally, show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Meme Image
                Center(
                  child: Image.asset(
                    'assets/images/app_icon.png', // Your meme logo or funny image
                    height: 140,
                  ),
                ),
                SizedBox(height: 5),
                // Welcome Text
                const Text(
                  'Welcome to Sound of Memes!',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 26,
                    fontFamily: 'ComicSansMS',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name TextField
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple[300],
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.white70),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 5) {
                            return 'Name must be at least 5 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple[300],
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.white70),
                        ),
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple[300],
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      // Signup Button
                      ElevatedButton(
                        onPressed: () => _signup(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'ComicSansMS',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Meme-Inspired Footer
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Log in!",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
