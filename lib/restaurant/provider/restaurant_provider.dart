import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/provider/pagination_provider.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }
  //기존 리스트에서 데이터 가져옴
  // NOTE: collection 패키지 추가 기존 firstWhere는 에러가 발생하자미나 이건 없으면 null
  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

//이렇게하면 모든 클래스가 들어갈 수 있다
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 만약에 데이터가 하나도 없는 상태라면

    if (state is! CursorPagination) {
      await this.paginate();
    }

    //5가지 가능성
    //1_ CursorPagination - 정상적으로 데이터가 있는 상태
    //2_ CursorPaginationLoading - 데이터가 로딩중인 상태 ( 현재 캐시 없음)
    //3_ CursorPaginationError - 에러가 있는 상태
    //4_ CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져 올떄
    //5_ CursorPaginationFetchMore - 추가 데이터를 paginate g애롸는 요청을 받았을떄
    //paginate를 가져온 후에도 계속 CursorPagination이 아니면 무언가 에러가 난거임
    // 즉 CursorPagination 상태가 데이터가 있는 상태임
    //state CUrsorPagination이 아닐떄
    if (state is! CursorPagination) {
      return;
    }

    final resp = await repository.getRestaurantDetail(id: id);
    final pState = state as CursorPagination;
    // NOTE: 음식탭에서 음식 클릭 시 레스토랑 정보가 없을 수도 있음 그럴 경우 그냥 뒤에 추가해버림
    // 여기서 pState는 레스토랑 리스트임
    // 이 경우 restaurant_detail에 37line 이 실행됨
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(data: [...pState.data, resp]);
    } else {
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>(
                (e) => e.id == id ? resp : e,
              )
              .toList());
    }
  }
}
