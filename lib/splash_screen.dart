import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sdgp_95/login/login_screen.dart';

import 'bottom_nav_bar.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization code here (e.g., data loading, etc.)
    // Example: Future.delayed(Duration(seconds: 2), () => navigateToHome());
    var future = Future.delayed(Duration(seconds: 2), () {
      // Navigate to the next screen after a delay of 2 seconds

      FirebaseAuth.instance
          .userChanges()
          .listen((User? user) {
        if (user == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else {
          print('User is signed in!');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
        }
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 2000, height: 500),
            SizedBox(height: 16),
            
          ],
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white // Set the background color for light mode
          : Colors.black, // Set the background color for dark mode
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to your app!'),
      ),
    );
  }
}
