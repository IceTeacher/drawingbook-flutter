part of 'audio_book_bloc.dart';

sealed class AudioBookEvent extends Equatable {
  const AudioBookEvent();

  @override
  List<Object?> get props => [];
}

class AudioBookStarted extends AudioBookEvent {
  const AudioBookStarted();
}

class AudioBookLanguageChanged extends AudioBookEvent {
  const AudioBookLanguageChanged(this.language);

  final int language;

  @override
  List<Object?> get props => [language];
}

class AudioBookMoreRequested extends AudioBookEvent {
  const AudioBookMoreRequested();
}

class AudioBookPlayRequested extends AudioBookEvent {
  const AudioBookPlayRequested(this.item);

  final AudioBookItem item;

  @override
  List<Object?> get props => [item];
}

class AudioBookContinuousPlayRequested extends AudioBookEvent {
  const AudioBookContinuousPlayRequested();
}

class AudioBookSeekRequested extends AudioBookEvent {
  const AudioBookSeekRequested(this.position);

  final Duration position;

  @override
  List<Object?> get props => [position];
}

class AudioBookClosePlayerRequested extends AudioBookEvent {
  const AudioBookClosePlayerRequested();
}

class _AudioBookPositionChanged extends AudioBookEvent {
  const _AudioBookPositionChanged(this.position);

  final Duration position;

  @override
  List<Object?> get props => [position];
}

class _AudioBookPlaybackCompleted extends AudioBookEvent {
  const _AudioBookPlaybackCompleted();
}
