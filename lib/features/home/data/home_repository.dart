import '../../../core/network/api_client.dart';
import '../../../shared/models/common_models.dart';

class HomeRepository {
  HomeRepository(this._client);

  final ApiClient _client;

  Future<HomePayload> loadInitial() async {
    final goodBookResponse = await _client.get(
      '/recommend/goodBookList',
      queryParameters: _blankSign(),
    );
    final bookListResponse = await _client.get(
      '/goods/getNecessaryGoodsList',
      queryParameters: {
        'perpage': 10,
        'goods_type': 1,
        'goods_position': 0,
        ..._blankSign(),
      },
    );
    final leaderboardResponse = await _client.get(
      '/leaderboard/homeLeaderboard',
      queryParameters: _blankSign(),
    );
    final categoryResponse = await _client.get(
      '/category/getFcList',
      queryParameters: {'position': 1, ..._blankSign()},
    );
    final talentGoods = await fetchTalentGoods(0);

    final categoryGroups = jsonList(categoryResponse['data']?['list']);
    final categories = categoryGroups.length > 2
        ? jsonList(
            categoryGroups[2]['tag_list'],
          ).map(CategoryItem.fromJson).toList()
        : <CategoryItem>[];

    return HomePayload(
      goodBooks: jsonList(
        goodBookResponse['data']?['single_list'],
      ).map(BookItem.fromJson).toList(),
      bookLists: jsonList(
        bookListResponse['data']?['list'],
      ).map(BookListItem.fromJson).toList(),
      leaderboards: jsonList(
        leaderboardResponse['data']?['list'],
      ).map(LeaderboardItem.fromJson).toList(),
      categories: categories,
      talentGoods: talentGoods,
    );
  }

  Future<List<BookItem>> fetchTalentGoods(int position) async {
    final response = await _client.get(
      '/goods/getTalentGoodsList',
      queryParameters: {
        'perpage': 10,
        'goods_type': 1,
        'goods_position': position,
        'from': 'index',
        ..._blankSign(),
      },
    );
    return jsonList(response['data']?['list']).map(BookItem.fromJson).toList();
  }

  Map<String, Object> _blankSign() => const {'sign': '', 'uid': ''};
}

class HomePayload {
  const HomePayload({
    required this.goodBooks,
    required this.bookLists,
    required this.leaderboards,
    required this.categories,
    required this.talentGoods,
  });

  final List<BookItem> goodBooks;
  final List<BookListItem> bookLists;
  final List<LeaderboardItem> leaderboards;
  final List<CategoryItem> categories;
  final List<BookItem> talentGoods;
}
