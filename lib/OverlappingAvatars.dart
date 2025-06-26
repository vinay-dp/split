import 'package:flutter/material.dart';
import 'package:split_share/user_avatar.dart';

class OverlappingAvatars extends StatelessWidget {
  final int count;

  const OverlappingAvatars({super.key, this.count = 2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 20.0 * count,
      height: 30,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(left: index * 20, child: UserAvatar());
        }),
      ),
    );
  }
}