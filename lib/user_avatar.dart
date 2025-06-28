import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? userName; // Made userName nullable

  const UserAvatar({super.key, this.userName}); // Added userName parameter

  @override
  Widget build(BuildContext context) {
    // Determine the initial to display
    // Uses the first letter of userName if available and not empty, otherwise defaults to '?'
    String initial = (userName != null && userName!.isNotEmpty) ? userName![0].toUpperCase() : '?';

    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff5B68FF), // Default color, can be made dynamic
        border: Border.all(width: 2, color: Colors.white),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}