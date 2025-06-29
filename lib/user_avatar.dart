import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? userName; // Made userName nullable
  final Color? backgroundColor; // Add backgroundColor parameter

  const UserAvatar({super.key, this.userName, this.backgroundColor}); // Update constructor

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
        color: backgroundColor ?? Color(0xff5B68FF), // Use provided color or default
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