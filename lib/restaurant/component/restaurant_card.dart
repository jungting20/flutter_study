import 'package:acture/common/const/colors.dart';
import 'package:acture/restaurant/model/restaurant_detail_model.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;
  final bool isDetail;
  final String? heroKey;
  final String? detail;

  const RestaurantCard({
    Key? key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    this.heroKey,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl),
      heroKey: model.id,
      name: model.name,
      tags: List<String>.from(model.tags),
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  //hero 여기만 추가 하도 되는 이유는 이거 현재 card는 공유를 해서 쓰지 리스트랑, 디테일이랑
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (isDetail) image,
      if (!isDetail)
        Hero(
          tag: ObjectKey(heroKey),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
              child: image),
        ),
      const SizedBox(height: 16.0),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16.0),
            Text(
              tags.join(' · '),
              style: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
            ),
            Row(children: [
              _IconText(icon: Icons.star, label: ratings.toString()),
              _IconText(icon: Icons.receipt, label: ratingsCount.toString()),
              _IconText(
                  icon: Icons.timelapse_outlined, label: '$deliveryTime 분'),
              _IconText(
                  icon: Icons.monetization_on,
                  label: deliveryFee == 0 ? '무료' : deliveryFee.toString()),
            ]),
            if (detail != null && isDetail)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(detail!),
              )
          ],
        ),
      )
    ]);
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
        Text(label, style: const TextStyle(fontSize: 14.0))
      ],
    );
  }
}
