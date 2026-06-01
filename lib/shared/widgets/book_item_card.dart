import 'package:flutter/material.dart';

import '../models/common_models.dart';
import 'avatar_card.dart';
import 'network_image_view.dart';

class BookItemCard extends StatelessWidget {
  const BookItemCard({
    super.key,
    required this.item,
    this.descMaxLines = 3,
    this.showLabels = false,
  });

  final BookItem item;
  final int descMaxLines;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            NetworkImageView(
              url: item.goodsThumb,
              width: 92,
              height: 122,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            Container(
              width: 16,
              height: 122,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x66989898), Color(0x00ffffff)],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 122,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.goodsName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff404040),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.goodsDesc,
                  maxLines: descMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: Color(0xff666666),
                  ),
                ),
                if (showLabels && item.labels.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: item.labels.take(3).map((label) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xffefefef),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff666666),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const Spacer(),
                AvatarCard(
                  avatar: item.expertInfo.avatar,
                  name: item.expertInfo.name,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
