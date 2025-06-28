import 'package:flutter/material.dart';
import 'package:split_share/user_avatar.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<String> users;

  const OverlappingAvatars({super.key, this.users = const []});

  @override
  Widget build(BuildContext context) {
    final displayUsersCount = users.length;

    return SizedBox(
      width: displayUsersCount > 0 ? (displayUsersCount * 20.0) + 10.0 : 0,
      height: 30,
      child: Stack(
        children: List.generate(displayUsersCount, (index) {
          return Positioned(
            left: index * 20.0, 
            // Pass the actual user name to UserAvatar
            child: UserAvatar(userName: users[index]), 
          );
        }),
      ),
    );
  }
}