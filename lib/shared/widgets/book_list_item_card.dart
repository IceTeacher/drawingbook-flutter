import 'package:flutter/material.dart';

import '../models/common_models.dart';
import 'avatar_card.dart';
import 'network_image_view.dart';

class BookListItemCard extends StatelessWidget {
  const BookListItemCard({
    super.key,
    required this.item,
    this.width,
    this.height = 340,
  });

  final BookListItem item;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xfff4f4f4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageView(
            url: item.goodsThumb,
            width: double.infinity,
            height: height >= 360 ? 190 : 160,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.goodsName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff404040),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              item.displayDescription,
              maxLines: height >= 360 ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.55,
                color: Color(0xff666666),
              ),
            ),
          ),
          AvatarCard(
            avatar: item.displayExpert.avatar,
            name: item.displayExpert.name,
          ),
        ],
      ),
    );
  }
}
