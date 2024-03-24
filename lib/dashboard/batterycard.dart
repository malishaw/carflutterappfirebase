import 'package:flutter/material.dart';

class BatteryCard extends StatefulWidget {
  final double batteryLevel;

  const BatteryCard({Key? key, required this.batteryLevel}) : super(key: key);

  @override
  _BatteryCardState createState() => _BatteryCardState();
}

class _BatteryCardState extends State<BatteryCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000), // Increased duration to 2000 milliseconds
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.batteryLevel,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BatteryCard oldWidget) {
    if (oldWidget.batteryLevel != widget.batteryLevel) {
      _animationController.reset();
      _animation = Tween<double>(
        begin: oldWidget.batteryLevel,
        end: widget.batteryLevel,
      ).animate(_animationController);
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final double batterySize = orientation == Orientation.portrait ? 64.0 : 128.0;
    final double textSize = orientation == Orientation.portrait ? 20.0 : 32.0;

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Battery Level',
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level: ${_animation.value.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: textSize * 0.7),
                ),
                SizedBox(
                  width: batterySize,
                  height: batterySize * 0.5,
                  child: Stack(
                    children: [
                      Container(
                        width: batterySize,
                        height: batterySize * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Container(
                        width: batterySize * (_animation.value / 100),
                        height: batterySize * 0.5,
                        decoration: BoxDecoration(
                          color: _animation.value >= 20 ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
