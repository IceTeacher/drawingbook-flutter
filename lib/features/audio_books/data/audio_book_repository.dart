import '../../../core/network/api_client.dart';
import '../../../shared/models/common_models.dart';

class AudioBookRepository {
  AudioBookRepository(this._client);

  final ApiClient _client;

  Future<List<AudioBookItem>> fetchAudioBooks({
    required int language,
    required int page,
  }) async {
    final response = await _client.get(
      '/goodsAudio/getList',
      queryParameters: {
        'page': page,
        'language': language,
        'perpage': 10,
        'sign': '',
        'uid': '',
      },
    );
    return jsonList(
      response['data']?['list'],
    ).map(AudioBookItem.fromJson).toList();
  }
}
