import 'package:acture/common/model/cursor_pagination_model.dart';
import 'package:acture/common/model/model_with_id.dart';
import 'package:acture/common/provider/pagination_provider.dart';
import 'package:acture/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView(
      {required this.provider, required this.itemBuilder, Key? key})
      : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
        controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // first Loading
    if (state is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    //error
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: Text('다시시도'),
          )
        ],
      );
    }

    final cp = state as CursorPagination<T>;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(
                  child: cp is CursorPaginationFechingMore
                      ? const CircularProgressIndicator()
                      : const Text('마지막 데이터입니다'));
            }

            final pItem = cp.data[index];
            return widget.itemBuilder(context, index, pItem);
          },
          separatorBuilder: (_, index) {
            return const SizedBox(height: 16.0);
          },
        ));
    ;
  }
}
