import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/common_models.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/avatar_card.dart';
import '../../../shared/widgets/error_retry.dart';
import '../../../shared/widgets/loading_item.dart';
import '../../../shared/widgets/network_image_view.dart';
import '../bloc/audio_book_bloc.dart';

class AudioBooksPage extends StatefulWidget {
  const AudioBooksPage({super.key});

  @override
  State<AudioBooksPage> createState() => _AudioBooksPageState();
}

class _AudioBooksPageState extends State<AudioBooksPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<AudioBookBloc>().add(const AudioBookMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBookBloc, AudioBookState>(
      builder: (context, state) {
        if (state.status == AudioBookStatus.loading ||
            state.status == AudioBookStatus.initial) {
          return const LoadingItem();
        }
        if (state.status == AudioBookStatus.failure) {
          return ErrorRetry(
            message: state.errorMessage,
            onRetry: () =>
                context.read<AudioBookBloc>().add(const AudioBookStarted()),
          );
        }

        return Stack(
          children: [
            ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                20,
                10,
                20,
                state.showPlayer ? 104 : 24,
              ),
              itemCount: state.items.length + (state.isLoadingMore ? 2 : 1),
              separatorBuilder: (_, index) {
                if (index == 0) {
                  return const SizedBox(height: 10);
                }
                return const SizedBox(height: 22);
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Column(
                    children: [
                      AppSearchBar(),
                      SizedBox(height: 10),
                      _AudioToolbar(),
                      Divider(height: 1, color: Color(0xffebebeb)),
                    ],
                  );
                }
                final itemIndex = index - 1;
                if (itemIndex >= state.items.length) {
                  return const LoadingItem();
                }
                final item = state.items[itemIndex];
                return GestureDetector(
                  onTap: () {
                    context.read<AudioBookBloc>().add(
                      const AudioBookClosePlayerRequested(),
                    );
                    context.push('/book/${item.goodsId}');
                  },
                  child: _AudioBookRow(item: item, state: state),
                );
              },
            ),
            if (state.showPlayer && state.currentItem != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: _AudioPlayerBar(state: state),
              ),
          ],
        );
      },
    );
  }
}

class _AudioToolbar extends StatelessWidget {
  const _AudioToolbar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBookBloc, AudioBookState>(
      buildWhen: (previous, current) =>
          previous.language != current.language ||
          previous.isPlaying != current.isPlaying,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              _LanguageButton(
                label: '国语',
                language: 0,
                selected: state.language == 0,
              ),
              const SizedBox(width: 8),
              _LanguageButton(
                label: '英语',
                language: 3,
                selected: state.language == 3,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => context.read<AudioBookBloc>().add(
                  const AudioBookContinuousPlayRequested(),
                ),
                icon: const Icon(Icons.queue_music, size: 18),
                label: const Text('连续播放'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff5cd3b4),
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.language,
    required this.selected,
  });

  final String label;
  final int language;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 28,
      child: OutlinedButton(
        onPressed: () {
          if (!selected) {
            context.read<AudioBookBloc>().add(
              AudioBookLanguageChanged(language),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: selected ? const Color(0xff5cd3b4) : Colors.white,
          foregroundColor: selected ? Colors.white : const Color(0xff5cd3b4),
          side: const BorderSide(color: Color(0xff5cd3b4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

class _AudioBookRow extends StatelessWidget {
  const _AudioBookRow({required this.item, required this.state});

  final AudioBookItem item;
  final AudioBookState state;

  @override
  Widget build(BuildContext context) {
    final isCurrent = state.currentItem?.id == item.id;
    final isPlaying = isCurrent && state.isPlaying;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            NetworkImageView(
              url: item.coverImage,
              width: 80,
              height: 100,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            Container(
              width: 14,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x66989898), Color(0x00ffffff)],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff404040),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: Color(0xff999999),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatClock(Duration(seconds: item.time)),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff999999),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.headphones,
                      size: 14,
                      color: Color(0xff999999),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.playNum,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff999999),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                AvatarCard(
                  avatar: item.expertInfo.avatar,
                  name: item.expertInfo.name,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 76,
          height: 32,
          child: FilledButton.icon(
            onPressed: () {
              context.read<AudioBookBloc>().add(AudioBookPlayRequested(item));
            },
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 18),
            label: Text(isPlaying ? '暂停' : '播放'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              backgroundColor: isPlaying
                  ? const Color(0xff6ad487)
                  : const Color(0xffff7b68),
              textStyle: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

class _AudioPlayerBar extends StatelessWidget {
  const _AudioPlayerBar({required this.state});

  final AudioBookState state;

  @override
  Widget build(BuildContext context) {
    final item = state.currentItem!;
    final durationMs = state.duration.inMilliseconds
        .toDouble()
        .clamp(1.0, double.infinity)
        .toDouble();
    final positionMs = state.position.inMilliseconds
        .toDouble()
        .clamp(0.0, durationMs)
        .toDouble();
    final remaining = state.duration - state.position;
    return Material(
      elevation: 10,
      color: const Color(0xcc333333),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.read<AudioBookBloc>().add(
                const AudioBookClosePlayerRequested(),
              ),
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: '关闭',
            ),
            NetworkImageView(
              url: item.expertInfo.avatar,
              width: 44,
              height: 44,
              borderRadius: BorderRadius.circular(5),
            ),
            Expanded(
              child: Slider(
                value: positionMs,
                min: 0,
                max: durationMs,
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                onChanged: (value) {
                  context.read<AudioBookBloc>().add(
                    AudioBookSeekRequested(
                      Duration(milliseconds: value.round()),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 44,
              child: Text(
                _formatClock(remaining.isNegative ? Duration.zero : remaining),
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () => context.read<AudioBookBloc>().add(
                AudioBookPlayRequested(item),
              ),
              icon: Icon(
                state.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: Colors.white,
                size: 34,
              ),
              tooltip: state.isPlaying ? '暂停' : '播放',
            ),
          ],
        ),
      ),
    );
  }
}

String _formatClock(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
