import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String property;
  final String propvalue;

  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.property,
    required this.propvalue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: 130,
       padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon,size: 32),
            SizedBox(height: 5),
            Text(property,style: TextStyle(fontSize: 14, fontFamily: 'Open Sans')),
             SizedBox(height: 5),
            Text(
              propvalue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
    );
  }
}
