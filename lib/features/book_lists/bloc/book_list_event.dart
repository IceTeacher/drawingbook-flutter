part of 'book_list_bloc.dart';

sealed class BookListEvent extends Equatable {
  const BookListEvent();

  @override
  List<Object?> get props => [];
}

class BookListStarted extends BookListEvent {
  const BookListStarted();
}

class BookListMoreRequested extends BookListEvent {
  const BookListMoreRequested();
}
