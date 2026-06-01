class Expert {
  const Expert({
    required this.id,
    required this.name,
    required this.avatar,
    required this.introduction,
  });

  factory Expert.fromJson(Map<String, dynamic>? json) {
    return Expert(
      id: _asString(json?['id'] ?? json?['expert_id']),
      name: _asString(json?['name']),
      avatar: _asString(json?['avatar']),
      introduction: _asString(
        json?['expert_introduction'] ??
            json?['introduction'] ??
            json?['description'] ??
            json?['user_title'],
      ),
    );
  }

  final String id;
  final String name;
  final String avatar;
  final String introduction;
}

class BookListItem {
  const BookListItem({
    required this.goodsId,
    required this.goodsName,
    required this.goodsDesc,
    required this.goodsThumb,
    required this.expertDescription,
    required this.expert,
    required this.expertInfo,
  });

  factory BookListItem.fromJson(Map<String, dynamic> json) {
    return BookListItem(
      goodsId: _asString(json['goods_id']),
      goodsName: _asString(json['goods_name']),
      goodsDesc: _asString(json['goods_desc']),
      goodsThumb: _asString(json['goods_thumb']),
      expertDescription: _asString(
        json['expert_description'] ?? json['expert_introduction'],
      ),
      expert: Expert.fromJson(_asMap(json['expert'])),
      expertInfo: Expert.fromJson(_asMap(json['expert_info'])),
    );
  }

  final String goodsId;
  final String goodsName;
  final String goodsDesc;
  final String goodsThumb;
  final String expertDescription;
  final Expert expert;
  final Expert expertInfo;

  Expert get displayExpert => expert.name.isNotEmpty ? expert : expertInfo;

  String get displayDescription {
    if (expertInfo.introduction.isNotEmpty) {
      return expertInfo.introduction;
    }
    if (expertDescription.isNotEmpty) {
      return expertDescription;
    }
    return goodsDesc;
  }
}

class BookItem {
  const BookItem({
    required this.goodsId,
    required this.goodsName,
    required this.goodsDesc,
    required this.goodsThumb,
    required this.expertInfo,
    required this.labels,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      goodsId: _asString(json['goods_id']),
      goodsName: _asString(json['goods_name']),
      goodsDesc: _asString(
        _asMap(json['expert_info'])?['expert_introduction'] ??
            _asMap(json['expert_speak_info'])?['description'] ??
            json['goods_desc'],
      ),
      goodsThumb: _asString(json['goods_thumb']),
      expertInfo: Expert.fromJson(
        _asMap(json['expert_info']) ?? _asMap(json['expert_speak_info']),
      ),
      labels: _asList(json['label_list'])
          .map((item) => _asString(_asMap(item)?['label_name']))
          .where((item) => item.isNotEmpty)
          .toList(),
    );
  }

  final String goodsId;
  final String goodsName;
  final String goodsDesc;
  final String goodsThumb;
  final Expert expertInfo;
  final List<String> labels;
}

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: _asString(json['id']),
      name: _asString(json['name']),
      image: _asString(json['image']),
    );
  }

  final String id;
  final String name;
  final String image;
}

class LeaderboardItem {
  const LeaderboardItem({
    required this.attrValId,
    required this.title,
    required this.images,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    final images = _asList(json['gallery'])
        .map((item) => Uri.decodeFull(_asString(_asMap(item)?['image'])))
        .where((item) => item.isNotEmpty)
        .toList();
    return LeaderboardItem(
      attrValId: _asString(json['attr_val_id']),
      title: _asString(json['title']),
      images: images,
    );
  }

  final String attrValId;
  final String title;
  final List<String> images;
}

class AudioBookItem {
  const AudioBookItem({
    required this.id,
    required this.goodsId,
    required this.title,
    required this.coverImage,
    required this.videoUrl,
    required this.time,
    required this.playNum,
    required this.expertInfo,
  });

  factory AudioBookItem.fromJson(Map<String, dynamic> json) {
    return AudioBookItem(
      id: _asString(json['id']),
      goodsId: _asString(json['goods_id']),
      title: _asString(json['title']),
      coverImage: _asString(json['cover_image']),
      videoUrl: _asString(json['video_url']),
      time: int.tryParse(_asString(json['time'])) ?? 0,
      playNum: _asString(json['play_num']),
      expertInfo: Expert.fromJson(_asMap(json['expert_info'])),
    );
  }

  final String id;
  final String goodsId;
  final String title;
  final String coverImage;
  final String videoUrl;
  final int time;
  final String playNum;
  final Expert expertInfo;
}

String _asString(Object? value) => value?.toString() ?? '';

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

List<Object?> _asList(Object? value) {
  if (value is List) {
    return value;
  }
  return const [];
}

List<Map<String, dynamic>> jsonList(Object? value) {
  return _asList(value).map(_asMap).whereType<Map<String, dynamic>>().toList();
}
