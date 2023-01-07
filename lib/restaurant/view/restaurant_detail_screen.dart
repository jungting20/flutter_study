import 'package:acture/common/layout/default_layout.dart';
import 'package:acture/product/component/product_card.dart';
import 'package:acture/rating/component/rating_card.dart';
import 'package:acture/restaurant/component/restaurant_card.dart';
import 'package:acture/restaurant/model/restaurant_detail_model.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/provider/restaurant_provider.dart';
import 'package:acture/restaurant/provider/restaurant_rating_provider.dart';
import 'package:acture/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    print(ratingState);

    if (state == null) {
      return const DefaultLayout(
          child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
        title: '불타는',
        child: CustomScrollView(slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: RatingCard(
                avatarImage: AssetImage('asset/img/logo/logo.png'),
                content: '맛있습니다',
                email: 'jc@codefactory.ai',
                images: [],
                rating: 4,
              ),
            ),
          )
        ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  SliverToBoxAdapter renderLabel() {
    return const SliverToBoxAdapter(
      child: Text(
        'Menu',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildListDelegate(List.generate(
              3,
              (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SkeletonParagraph(
                        style: const SkeletonParagraphStyle(
                            lines: 5, padding: EdgeInsets.zero)),
                  )))),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(child: RestaurantCard.fromModel(model: model));
  }
}
