import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sdgp_95/reminder/reminder_screen.dart';
import 'package:sdgp_95/shop/shop_page.dart';

import 'dashboard/dashboard_page.dart';
import 'menu.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    ReminderPage(),
    ShopPage(),
    Text('Menu Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar Example'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.notification),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.menu_1),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 3) {
           showCustomMenu(context); // Call function from menu.dart with custom prefix
          } else {
            _onItemTapped(index);
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your action here
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
