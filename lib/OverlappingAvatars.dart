import 'package:flutter/material.dart';
import 'package:split_share/user_avatar.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<Map<String, dynamic>> users; // Now expects a list of user maps with name and color

  const OverlappingAvatars({super.key, this.users = const []});

  @override
  Widget build(BuildContext context) {
    final displayUsersCount = users.length;

    return SizedBox(
      width: displayUsersCount > 0 ? (displayUsersCount * 20.0) + 10.0 : 0,
      height: 30,
      child: Stack(
        children: List.generate(displayUsersCount, (index) {
          final user = users[index];
          return Positioned(
            left: index * 20.0, 
            child: UserAvatar(
              userName: user['name'],
              backgroundColor: user['color'],
            ),
          );
        }),
      ),
    );
  }
}