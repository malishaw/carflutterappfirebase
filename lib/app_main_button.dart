import 'package:flutter/material.dart';

class AppMainButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final IconData? icon;

  const AppMainButton(
      {super.key, required this.text, required this.onPressed, this.width, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 70,
      decoration:  const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ), // Adjust corner radius
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white,),
          TextButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white, // White font color
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
