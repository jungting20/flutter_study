//인터페이스로 사용할 수 있음
import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/model/model_with_id.dart';
import 'package:acture/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
