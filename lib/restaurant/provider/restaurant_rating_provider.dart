import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/model/pagination_params.dart';
import 'package:acture/common/provider/pagination_provider.dart';
import 'package:acture/rating/model/rating_model.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
  final repo = ref.watch(restaurantRatingRepositoryProvider(id));
  return RestaurantRatingStateNotifier(repository: repo);
});

//이렇게하면 모든 클래스가 들어갈 수 있다
class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({
    required super.repository,
  });
}
