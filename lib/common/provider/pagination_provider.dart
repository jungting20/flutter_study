import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/model/model_with_id.dart';
import 'package:acture/common/model/pagination_params.dart';
import 'package:acture/common/repostory/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate(
      {int fetchCount = 20,
      //true 추가로 데이터 더 가져옴
      // false - 새로고침 ( 현재 상태를 덮어씌움)
      bool fetchMore = false,
      //아예 새롭게 리스트를 바꿔버림
      bool forceRefetch = false}) async {
    try {
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
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore
      //데이터를 추가로 더 가져오는 상황

      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state =
            CursorPaginationFechingMore(meta: pState.meta, data: pState.data);

        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      }
// 데이터를 처음부터 가져오는 상황
      else {
// 만약에 데이터가 있는 상황이라면
// 기존 데이터를 보존한채로 Fetch (API 요청)을 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        }
        //나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      //
      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (isFetchingMore) {
        final pState = state as CursorPaginationFechingMore<T>;

        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(stack);
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다.");
    }
  }
}
