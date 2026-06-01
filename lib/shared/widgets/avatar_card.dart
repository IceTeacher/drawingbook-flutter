import 'package:flutter/material.dart';

import 'network_image_view.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({super.key, required this.avatar, required this.name});

  final String avatar;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (avatar.isEmpty && name.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NetworkImageView(
          url: avatar,
          width: 28,
          height: 28,
          borderRadius: BorderRadius.circular(14),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xff666666)),
          ),
        ),
      ],
    );
  }
}
