import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sdgp_95/login/authentication.dart';
import 'package:sdgp_95/reminder/reminder_screen.dart';
import 'package:sdgp_95/upload_image/upload_image_screen.dart';
import 'package:sdgp_95/vehicle/vehicle_add_update.dart';
import 'package:sdgp_95/vehicle/vehicle_page.dart';

import 'login/login_screen.dart';

void showCustomMenu(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FullScreenMenu()),
  );
}

class FullScreenMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Iconsax.notification),
            title: Text('Add Reminder'),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderPage()), // Navigate to Add Reminder page
              );
            },
          ),
          ListTile(
            leading: Icon(Iconsax.image),
            title: Text('Upload Image'),
            onTap: () {
              // Implement upload image functionality here
              Navigator.pop(context);// Close the menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadImageScreen()), // Navigate to Add Reminder page
              );
            },
          ),
          ListTile(
            leading: Icon(Iconsax.car),
            title: const Text('Vehicle'),
            onTap: () {
              // Implement upload image functionality here
              Navigator.pop(context);// Close the menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VehicleUpdateAddPage()), // Navigate to Add Reminder page
              );
            },
          ),
          ListTile(
            leading: Icon(Iconsax.logout),
            title: const Text('Logout'),
            onTap: () {
              // Implement upload image functionality here
              Navigator.pop(context);// Close the menu
              AuthenticationHelper().signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()), // Navigate to Add Reminder page
              );
            },
          ),
        ],
      ),
    );
  }
}
