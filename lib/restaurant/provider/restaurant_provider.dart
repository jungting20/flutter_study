import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/model/pagination_params.dart';
import 'package:acture/restaurant/model/restaurant_model.dart';
import 'package:acture/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

//이렇게하면 모든 클래스가 들어갈 수 있다
class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    //생성자 초기값으로([]) 세팅 해주고 paginate는 await 걸려있으니까 끝나고나면 state 전역 변수에 data를 셋하지
    // 그러면 state가 변하니까 이거 불러다 쓴데는 리렌더링 됨 useEffect 생각하면 될듯
    paginate();
  }

  void paginate(
      {int fetchCount = 20,
      //true 추가로 데이터 더 가져옴
      // false - 새로고침 ( 현재 상태를 덮어씌움)
      bool fetchMore = false,
      //아예 새롭게 리스트를 바꿔버림
      bool forceRefetch = false}) async {
    //5가지 가능성
    //1_ CursorPagination - 정상적으로 데이터가 있는 상태
    //2_ CursorPaginationLoading - 데이터가 로딩중인 상태 ( 현재 캐시 없음)
    //3_ CursorPaginationError - 에러가 있는 상태
    //4_ CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져 올떄
    //5_ CursorPaginationFetchMore - 추가 데이터를 paginate g애롸는 요청을 받았을떄

    // 바로 반환하는 상황
    // hasmore가 = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
    // 로딩중 - fetchMore : true
    //    fetchMore 가 아닐떄 - 새로고침의 의도가 있다
    if (state is CursorPagination && !forceRefetch) {
      final pState = state as CursorPagination;
      if (!pState.meta.hasMore) {
        return;
      }
    }

    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFechingMore;

    //2q번
    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    //PaginationParam t애성
    PaginationParams paginationParmas = PaginationParams(count: fetchCount);
  }
}
