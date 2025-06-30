import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatelessWidget {
  final String? userName;
  final Color? backgroundColor;

  const UserAvatar({super.key, this.userName, this.backgroundColor});

  Color _getColorFromName(String? name) {
    if (name == null || name.isEmpty) return Color(0xff5B68FF);
    final hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    final rand = Random(hash);
    return Color.fromARGB(
      255,
      100 + rand.nextInt(156),
      100 + rand.nextInt(156),
      100 + rand.nextInt(156),
    );
  }

  @override
  Widget build(BuildContext context) {
    String initial = (userName != null && userName!.isNotEmpty) ? userName![0].toUpperCase() : '?';

    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? _getColorFromName(userName),
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