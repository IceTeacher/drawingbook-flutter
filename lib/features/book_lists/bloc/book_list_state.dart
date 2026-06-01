part of 'book_list_bloc.dart';

enum BookListStatus { initial, loading, success, failure }

class BookListState extends Equatable {
  const BookListState({
    this.status = BookListStatus.initial,
    this.items = const [],
    this.position = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage = '',
  });

  final BookListStatus status;
  final List<BookListItem> items;
  final int position;
  final bool hasMore;
  final bool isLoadingMore;
  final String errorMessage;

  BookListState copyWith({
    BookListStatus? status,
    List<BookListItem>? items,
    int? position,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return BookListState(
      status: status ?? this.status,
      items: items ?? this.items,
      position: position ?? this.position,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    position,
    hasMore,
    isLoadingMore,
    errorMessage,
  ];
}
