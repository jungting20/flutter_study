import 'package:acture/common/const/data.dart';
import 'package:acture/common/dio/dio.dart';
import 'package:acture/common/layout/default_layout.dart';
import 'package:acture/product/component/product_card.dart';
import 'package:acture/restaurant/component/restaurant_card.dart';
import 'package:acture/restaurant/model/restaurant_detail_model.dart';
import 'package:acture/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: ref
              .watch(restaurantRepositoryProvider)
              .getRestaurantDetail(id: id),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // final item = RestaurantDetailModel.fromJson(snapshot.data!);

            return CustomScrollView(slivers: [
              renderTop(),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ]);
          }),
    );
  }

  SliverToBoxAdapter renderLabel() {
    return SliverToBoxAdapter(
      child: Text(
        'Menu',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(childCount: products.length,
            (context, index) {
          final model = products[index];

          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(model: model),
          );
        }),
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: '불타는 떡볶이',
        tags: const ['떡볶이', '맛있음', '치즈'],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryFee: 3000,
        ratings: 4.76,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }
}