import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/restaurant/component/restaurant_card.dart';
import 'package:acture/restaurant/provider/restaurant_provider.dart';
import 'package:acture/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() =>
      _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if (controller.offset >
        controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // first Loading
    if (data is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    //error
    if (data is CursorPaginationError) {
      return Center(child: Text(data.message));
    }

    //CursroPagination
    //CursroPaginationFetchingMore
    //CursroPaginationRefetching

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                controller: controller,
                itemCount: cp.data.length + 1,
                itemBuilder: (_, index) {
                  if (index == cp.data.length) {
                    return Center(
                        child: data is CursorPaginationFechingMore
                            ? const CircularProgressIndicator()
                            : const Text('마지막 데이터입니다'));
                  }

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
