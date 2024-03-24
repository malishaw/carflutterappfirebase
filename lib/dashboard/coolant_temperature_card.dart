import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class CoolantTemperatureCard extends StatelessWidget {
  final double coolantTemperature;

  const CoolantTemperatureCard({required this.coolantTemperature});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Coolant Temperature',
      value: '$coolantTemperature °C',
      content: CustomTemperatureGauge(temperature: coolantTemperature),
    );
  }
}

class CustomTemperatureGauge extends StatefulWidget {
  final double temperature;

  CustomTemperatureGauge({required this.temperature});

  @override
  _CustomTemperatureGaugeState createState() => _CustomTemperatureGaugeState();
}

class _CustomTemperatureGaugeState extends State<CustomTemperatureGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Slower animation duration
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.temperature / 150.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward(); // Start the animation
  }

  @override
  void didUpdateWidget(covariant CustomTemperatureGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.temperature / 150.0,
      duration: Duration(seconds: 2), // Slower animation duration
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double gaugeWidth = 20.0;
    final double gaugeHeight = 200.0;
    final double radius = gaugeWidth / 2;

    return Container(
      width: gaugeWidth,
      height: gaugeHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: 2.0), // Dark border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background Gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 33, 147, 240),
                      Color.fromARGB(255, 0, 16, 41),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Temperature Indicator
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: gaugeHeight * _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade400,
                        const Color.fromARGB(255, 54, 0, 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
