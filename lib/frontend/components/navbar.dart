import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.only(left: 30),
        child: Icon(
          Icons.logo_dev_rounded,
          color: Color(0xFF33B0E9),
          size: 40,
        ),
      ),
      title: const Text(
        'DDV',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      elevation: 0,
    );
  }
}
