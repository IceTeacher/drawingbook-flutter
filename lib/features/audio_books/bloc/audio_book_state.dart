part of 'audio_book_bloc.dart';

enum AudioBookStatus { initial, loading, success, failure }

class AudioBookState extends Equatable {
  const AudioBookState({
    this.status = AudioBookStatus.initial,
    this.items = const [],
    this.language = 0,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentItem,
    this.isPlaying = false,
    this.showPlayer = false,
    this.position = Duration.zero,
    this.errorMessage = '',
  });

  final AudioBookStatus status;
  final List<AudioBookItem> items;
  final int language;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final AudioBookItem? currentItem;
  final bool isPlaying;
  final bool showPlayer;
  final Duration position;
  final String errorMessage;

  Duration get duration {
    final seconds = currentItem?.time ?? 0;
    return Duration(seconds: seconds);
  }

  AudioBookState copyWith({
    AudioBookStatus? status,
    List<AudioBookItem>? items,
    int? language,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    AudioBookItem? currentItem,
    bool clearCurrentItem = false,
    bool? isPlaying,
    bool? showPlayer,
    Duration? position,
    String? errorMessage,
  }) {
    return AudioBookState(
      status: status ?? this.status,
      items: items ?? this.items,
      language: language ?? this.language,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentItem: clearCurrentItem ? null : currentItem ?? this.currentItem,
      isPlaying: isPlaying ?? this.isPlaying,
      showPlayer: showPlayer ?? this.showPlayer,
      position: position ?? this.position,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    language,
    page,
    hasMore,
    isLoadingMore,
    currentItem,
    isPlaying,
    showPlayer,
    position,
    errorMessage,
  ];
}
