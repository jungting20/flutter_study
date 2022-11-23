import 'package:acture/common/const/colors.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;

  const RestaurantCard({
    Key? key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12.0), child: image),
        const SizedBox(height: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16.0),
            Text(
              tags.join(' · '),
              style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
            ),
            Row(children: [
              _IconText(icon: Icons.star, label: ratings.toString()),
              _IconText(icon: Icons.receipt, label: ratingsCount.toString()),
              _IconText(icon: Icons.timelapse_outlined, label: '$deliveryTime 분'),
              _IconText(icon: Icons.monetization_on, label:deliveryFee == 0 ? '무료': deliveryFee.toString()),
            ])
          ],
        )
      ]),
    );
  }
}

class _IconText extends StatelessWidget {
  //Icon. 데이터
  final IconData icon;
  final String label;

  const _IconText({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: PRIMART_COLOR, size: 14.0),
        const SizedBox(width: 8.0),
        Text(label, style: TextStyle(fontSize: 14.0))
      ],
    );
  }
}
