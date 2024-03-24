import 'package:flutter/material.dart';

class MileageCard extends StatefulWidget {
  final double mileageLevel;

  const MileageCard({Key? key, required this.mileageLevel}) : super(key: key);

  @override
  _MileageCardState createState() => _MileageCardState();
}

class _MileageCardState extends State<MileageCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Animation duration
    );

    _animation = Tween<double>(begin: 0, end: widget.mileageLevel).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Animation curve
      ),
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mileage',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Adjust color for emphasis
              ),
            ),
            SizedBox(height: 12.0), // Increased spacing for better readability
            Divider(color: Colors.grey), // Divider for visual separation
            SizedBox(height: 12.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Align content to center horizontally
                  children: [
                    Text(
                      '${_animation.value.toStringAsFixed(2)} Kilometers', // Use animation value
                      style: TextStyle(
                        fontSize: 28.0, // Reduced font size for better readability
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Adjust color for better contrast
                      ),
                    ),
                    SizedBox(width: 8.0), // Added spacing between text and icon
                    Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.blue, // Adjust icon color for consistency
                      size: 32.0, // Adjust icon size for better visibility
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
