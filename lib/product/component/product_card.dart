import 'package:acture/common/const/colors.dart';
import 'package:acture/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard(
      {required this.image,
      required this.name,
      required this.detail,
      required this.price,
      Key? key})
      : super(key: key);

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
      image: Image.network(model.imgUrl,
          width: 110, height: 110, fit: BoxFit.cover),
      name: model.name,
      price: model.price,
      detail: model.detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset('asset/img/food/ddeok_bok_gi.jpg',
                width: 110, height: 110, fit: BoxFit.cover),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '떡볶이',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                '떡볶이',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
              ),
              Text(
                'W10000',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: PRIMART_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
