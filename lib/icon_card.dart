import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final IconData icon;
  final String label;

  IconCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey[800]),
          SizedBox(height: 10),
          Text(label, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }
}
