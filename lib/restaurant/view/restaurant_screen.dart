import 'package:acture/common/const/data.dart';
import 'package:acture/common/dio/dio.dart';
import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/restaurant/component/restaurant_card.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/provider/restaurant_provider.dart';
import 'package:acture/restaurant/repository/restaurant_repository.dart';
import 'package:acture/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final cp = data as CursorPagination;

    return Container(
      child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                itemCount: cp.data.length,
                itemBuilder: (_, index) {
                  final pItem = cp.data[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                          ),
                        ));
                      },
                      child: RestaurantCard.fromModel(model: pItem));
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(height: 16.0);
                },
              ))),
    );
  }
}
