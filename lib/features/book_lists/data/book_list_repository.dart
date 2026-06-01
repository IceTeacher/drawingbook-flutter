import '../../../core/network/api_client.dart';
import '../../../shared/models/common_models.dart';

class BookListRepository {
  BookListRepository(this._client);

  final ApiClient _client;

  Future<List<BookListItem>> fetchBookLists(int position) async {
    final response = await _client.get(
      '/goods/getNecessaryGoodsList',
      queryParameters: {
        'perpage': 10,
        'goods_type': 1,
        'goods_position': position,
        'sign': '',
        'uid': '',
      },
    );
    return jsonList(
      response['data']?['list'],
    ).map(BookListItem.fromJson).toList();
  }
}
