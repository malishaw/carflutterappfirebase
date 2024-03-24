import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function onPressed;

  MyFloatingActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xff1e366e),
      onPressed: () {
        // Call the onPressed function passed from MyHomePage
        onPressed();
      },
      child: Icon(Icons.add),
    );
  }
} 