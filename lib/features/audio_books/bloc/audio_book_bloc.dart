import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../shared/models/common_models.dart';
import '../data/audio_book_repository.dart';

part 'audio_book_event.dart';
part 'audio_book_state.dart';

class AudioBookBloc extends Bloc<AudioBookEvent, AudioBookState> {
  AudioBookBloc(this._repository) : super(const AudioBookState()) {
    on<AudioBookStarted>(_onStarted);
    on<AudioBookLanguageChanged>(_onLanguageChanged);
    on<AudioBookMoreRequested>(_onMoreRequested);
    on<AudioBookPlayRequested>(_onPlayRequested);
    on<AudioBookContinuousPlayRequested>(_onContinuousPlayRequested);
    on<AudioBookSeekRequested>(_onSeekRequested);
    on<AudioBookClosePlayerRequested>(_onClosePlayerRequested);
    on<_AudioBookPositionChanged>(_onPositionChanged);
    on<_AudioBookPlaybackCompleted>(_onPlaybackCompleted);

    _positionSub = _player.positionStream.listen((position) {
      add(_AudioBookPositionChanged(position));
    });
    _playerStateSub = _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(const _AudioBookPlaybackCompleted());
      }
    });
  }

  final AudioBookRepository _repository;
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<PlayerState> _playerStateSub;

  Future<void> _onStarted(
    AudioBookStarted event,
    Emitter<AudioBookState> emit,
  ) async {
    await _loadFirstPage(emit, language: state.language);
  }

  Future<void> _onLanguageChanged(
    AudioBookLanguageChanged event,
    Emitter<AudioBookState> emit,
  ) async {
    await _stopPlayback(emit);
    emit(state.copyWith(language: event.language));
    await _loadFirstPage(emit, language: event.language);
  }

  Future<void> _loadFirstPage(
    Emitter<AudioBookState> emit, {
    required int language,
  }) async {
    emit(
      state.copyWith(
        status: AudioBookStatus.loading,
        page: 1,
        items: const [],
        hasMore: true,
        errorMessage: '',
      ),
    );
    try {
      final items = await _repository.fetchAudioBooks(
        language: language,
        page: 1,
      );
      emit(
        state.copyWith(
          status: AudioBookStatus.success,
          items: items,
          hasMore: items.length == 10,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioBookStatus.failure,
          errorMessage: '故事加载失败：$error',
        ),
      );
    }
  }

  Future<void> _onMoreRequested(
    AudioBookMoreRequested event,
    Emitter<AudioBookState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final items = await _repository.fetchAudioBooks(
        language: state.language,
        page: nextPage,
      );
      emit(
        state.copyWith(
          items: [...state.items, ...items],
          page: nextPage,
          hasMore: items.length == 10,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onPlayRequested(
    AudioBookPlayRequested event,
    Emitter<AudioBookState> emit,
  ) async {
    await _playOrToggle(event.item, emit);
  }

  Future<void> _onContinuousPlayRequested(
    AudioBookContinuousPlayRequested event,
    Emitter<AudioBookState> emit,
  ) async {
    final target =
        state.currentItem ??
        (state.items.isNotEmpty ? state.items.first : null);
    if (target == null) {
      return;
    }
    if (state.currentItem?.id == target.id && !state.isPlaying) {
      await _player.play();
      emit(state.copyWith(isPlaying: true, showPlayer: true));
      return;
    }
    await _startItem(target, emit);
  }

  Future<void> _playOrToggle(
    AudioBookItem item,
    Emitter<AudioBookState> emit,
  ) async {
    if (state.currentItem?.id == item.id) {
      if (state.isPlaying) {
        await _player.pause();
        emit(state.copyWith(isPlaying: false, showPlayer: true));
      } else {
        await _player.play();
        emit(state.copyWith(isPlaying: true, showPlayer: true));
      }
      return;
    }
    await _startItem(item, emit);
  }

  Future<void> _startItem(
    AudioBookItem item,
    Emitter<AudioBookState> emit,
  ) async {
    if (item.videoUrl.isEmpty) {
      return;
    }
    await _player.stop();
    await _player.setUrl(item.videoUrl);
    await _player.play();
    emit(
      state.copyWith(
        currentItem: item,
        isPlaying: true,
        showPlayer: true,
        position: Duration.zero,
      ),
    );
  }

  Future<void> _onSeekRequested(
    AudioBookSeekRequested event,
    Emitter<AudioBookState> emit,
  ) async {
    await _player.seek(event.position);
    emit(state.copyWith(position: event.position));
  }

  Future<void> _onClosePlayerRequested(
    AudioBookClosePlayerRequested event,
    Emitter<AudioBookState> emit,
  ) async {
    await _stopPlayback(emit);
  }

  void _onPositionChanged(
    _AudioBookPositionChanged event,
    Emitter<AudioBookState> emit,
  ) {
    if (state.showPlayer) {
      emit(state.copyWith(position: event.position));
    }
  }

  Future<void> _onPlaybackCompleted(
    _AudioBookPlaybackCompleted event,
    Emitter<AudioBookState> emit,
  ) async {
    final current = state.currentItem;
    if (current == null) {
      return;
    }
    final currentIndex = state.items.indexWhere(
      (item) => item.id == current.id,
    );
    final nextIndex = currentIndex + 1;
    if (currentIndex >= 0 && nextIndex < state.items.length) {
      await _startItem(state.items[nextIndex], emit);
    } else {
      await _player.pause();
      await _player.seek(Duration.zero);
      emit(state.copyWith(isPlaying: false, position: Duration.zero));
    }
  }

  Future<void> _stopPlayback(Emitter<AudioBookState> emit) async {
    await _player.stop();
    emit(
      state.copyWith(
        isPlaying: false,
        showPlayer: false,
        position: Duration.zero,
        clearCurrentItem: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _positionSub.cancel();
    await _playerStateSub.cancel();
    await _player.dispose();
    return super.close();
  }
}
