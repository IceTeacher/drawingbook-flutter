import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/common_models.dart';
import '../data/book_list_repository.dart';

part 'book_list_event.dart';
part 'book_list_state.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  BookListBloc(this._repository) : super(const BookListState()) {
    on<BookListStarted>(_onStarted);
    on<BookListMoreRequested>(_onMoreRequested);
  }

  final BookListRepository _repository;

  Future<void> _onStarted(
    BookListStarted event,
    Emitter<BookListState> emit,
  ) async {
    emit(const BookListState(status: BookListStatus.loading));
    try {
      final items = await _repository.fetchBookLists(0);
      emit(
        state.copyWith(
          status: BookListStatus.success,
          items: items,
          position: 0,
          hasMore: items.length == 10,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: BookListStatus.failure,
          errorMessage: '书单加载失败：$error',
        ),
      );
    }
  }

  Future<void> _onMoreRequested(
    BookListMoreRequested event,
    Emitter<BookListState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.position >= 5) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPosition = state.position + 1;
      final items = await _repository.fetchBookLists(nextPosition);
      emit(
        state.copyWith(
          items: [...state.items, ...items],
          position: nextPosition,
          hasMore: items.length == 10 && nextPosition < 5,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
