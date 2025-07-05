import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final double temp;
  const HourlyForecast({
    super.key, required this.time, required this.icon, required this.temp,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Icon(icon, size: 32),
 
            const SizedBox(height: 8),

            Text(temp.toStringAsFixed(1), style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
