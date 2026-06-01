part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.goodBooks = const [],
    this.bookLists = const [],
    this.leaderboards = const [],
    this.categories = const [],
    this.talentGoods = const [],
    this.talentPosition = 0,
    this.hasMoreTalent = true,
    this.isLoadingMoreTalent = false,
    this.errorMessage = '',
  });

  final HomeStatus status;
  final List<BookItem> goodBooks;
  final List<BookListItem> bookLists;
  final List<LeaderboardItem> leaderboards;
  final List<CategoryItem> categories;
  final List<BookItem> talentGoods;
  final int talentPosition;
  final bool hasMoreTalent;
  final bool isLoadingMoreTalent;
  final String errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<BookItem>? goodBooks,
    List<BookListItem>? bookLists,
    List<LeaderboardItem>? leaderboards,
    List<CategoryItem>? categories,
    List<BookItem>? talentGoods,
    int? talentPosition,
    bool? hasMoreTalent,
    bool? isLoadingMoreTalent,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      goodBooks: goodBooks ?? this.goodBooks,
      bookLists: bookLists ?? this.bookLists,
      leaderboards: leaderboards ?? this.leaderboards,
      categories: categories ?? this.categories,
      talentGoods: talentGoods ?? this.talentGoods,
      talentPosition: talentPosition ?? this.talentPosition,
      hasMoreTalent: hasMoreTalent ?? this.hasMoreTalent,
      isLoadingMoreTalent: isLoadingMoreTalent ?? this.isLoadingMoreTalent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    goodBooks,
    bookLists,
    leaderboards,
    categories,
    talentGoods,
    talentPosition,
    hasMoreTalent,
    isLoadingMoreTalent,
    errorMessage,
  ];
}
