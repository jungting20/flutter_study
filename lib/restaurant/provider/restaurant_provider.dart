import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
        (ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    //생성자 초기값으로([]) 세팅 해주고 paginate는 await 걸려있으니까 끝나고나면 state 전역 변수에 data를 셋하지
    // 그러면 state가 변하니까 이거 불러다 쓴데는 리렌더링 됨 useEffect 생각하면 될듯
    paginate();
  }

  paginate() async {
    final resp = await repository.paginate();

    state = resp.data;
  }
}
