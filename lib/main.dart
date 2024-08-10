import 'package:flutter/material.dart';

import 'Views/Auth/SignupScreen.dart';
import 'Views/Auth/auth_service.dart';
import 'Views/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound of Memes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 252, 176, 252),
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: AuthService().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          } else {
            return SignupScreen(); // Redirect to signup if no token is found
          }
        },
      ),
    );
  }
}
