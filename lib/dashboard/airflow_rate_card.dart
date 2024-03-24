import 'package:flutter/material.dart';

class AirflowRateCard extends StatelessWidget {
  final double airflowRate;

  const AirflowRateCard({required this.airflowRate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Airflow Rate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$airflowRate g/sec',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  Icons.wind_power_rounded,
                  color: Colors.blue,
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
