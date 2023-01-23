import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/provider/pagination_provider.dart';
import 'package:acture/product/model/product_model.dart';
import 'package:acture/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvicer);

  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({required super.repository});
}
