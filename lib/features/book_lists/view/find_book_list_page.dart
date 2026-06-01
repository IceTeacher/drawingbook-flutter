import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/book_list_item_card.dart';
import '../../../shared/widgets/error_retry.dart';
import '../../../shared/widgets/loading_item.dart';
import '../bloc/book_list_bloc.dart';

class FindBookListPage extends StatefulWidget {
  const FindBookListPage({super.key});

  @override
  State<FindBookListPage> createState() => _FindBookListPageState();
}

class _FindBookListPageState extends State<FindBookListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<BookListBloc>().add(const BookListMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListBloc, BookListState>(
      builder: (context, state) {
        if (state.status == BookListStatus.loading ||
            state.status == BookListStatus.initial) {
          return const LoadingItem();
        }
        if (state.status == BookListStatus.failure) {
          return ErrorRetry(
            message: state.errorMessage,
            onRetry: () =>
                context.read<BookListBloc>().add(const BookListStarted()),
          );
        }
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          itemCount: state.items.length + (state.isLoadingMore ? 2 : 1),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const AppSearchBar();
            }
            final itemIndex = index - 1;
            if (itemIndex >= state.items.length) {
              return const LoadingItem();
            }
            final item = state.items[itemIndex];
            return GestureDetector(
              onTap: () => context.push('/book-list/${item.goodsId}'),
              child: BookListItemCard(item: item, height: 380),
            );
          },
        );
      },
    );
  }
}
