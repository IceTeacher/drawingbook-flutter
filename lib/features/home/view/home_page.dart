import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/common_models.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/book_item_card.dart';
import '../../../shared/widgets/book_list_item_card.dart';
import '../../../shared/widgets/error_retry.dart';
import '../../../shared/widgets/loading_item.dart';
import '../../../shared/widgets/network_image_view.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      context.read<HomeBloc>().add(const HomeTalentMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading ||
            state.status == HomeStatus.initial) {
          return const LoadingItem();
        }
        if (state.status == HomeStatus.failure) {
          return ErrorRetry(
            message: state.errorMessage,
            onRetry: () => context.read<HomeBloc>().add(const HomeStarted()),
          );
        }
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: AppSearchBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: _Section(
                title: '好书速递',
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 12,
                      bottom: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.goodBooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final item = state.goodBooks[index];
                      return _GoodBookCard(
                        item: item,
                        onTap: () => context.push('/book/${item.goodsId}'),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _CategoryGrid(categories: state.categories),
            ),
            SliverToBoxAdapter(
              child: _Section(
                title: '达人书单',
                trailing: GestureDetector(
                  onTap: () => context.go('/find-book-lists'),
                  child: const Text(
                    '37个书单 >',
                    style: TextStyle(fontSize: 14, color: Color(0xff999999)),
                  ),
                ),
                subtitle: '200位阅读推广人联手推荐',
                child: SizedBox(
                  height: 360,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.bookLists.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final item = state.bookLists[index];
                      return GestureDetector(
                        onTap: () => context.push('/book-list/${item.goodsId}'),
                        child: BookListItemCard(item: item, width: 280),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _Section(
                title: '热门榜单',
                trailing: GestureDetector(
                  onTap: () => context.push('/rank/668'),
                  child: const Text(
                    '详细榜单 >',
                    style: TextStyle(fontSize: 14, color: Color(0xff999999)),
                  ),
                ),
                child: SizedBox(
                  height: 210,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.leaderboards.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final item = state.leaderboards[index];
                      return _LeaderboardCard(
                        item: item,
                        onTap: () => context.push('/rank/${item.attrValId}'),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionHeader(title: '达人精选', subtitle: '8年绘本馆馆长精选绘本'),
            ),
            SliverList.separated(
              itemCount: state.talentGoods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 22),
              itemBuilder: (context, index) {
                final item = state.talentGoods[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => context.push('/book/${item.goodsId}'),
                    child: BookItemCard(item: item),
                  ),
                );
              },
            ),
            if (state.isLoadingMoreTalent)
              const SliverToBoxAdapter(child: LoadingItem()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, subtitle: subtitle, trailing: trailing),
        child,
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xff404040),
            ),
          ),
          ...?_subtitleWidgets(subtitle),
          if (subtitle == null) const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

List<Widget>? _subtitleWidgets(String? subtitle) {
  if (subtitle == null) {
    return null;
  }
  return [
    const SizedBox(width: 8),
    Expanded(
      child: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, color: Color(0xff999999)),
      ),
    ),
  ];
}

class _GoodBookCard extends StatelessWidget {
  const _GoodBookCard({required this.item, required this.onTap});

  final BookItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xfff4f4f4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageView(
              url: item.goodsThumb,
              width: 92,
              height: 130,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff404040),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.goodsDesc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xff666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<CategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    final visible = categories.take(10).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visible.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisExtent: 78,
        ),
        itemBuilder: (context, index) {
          final item = visible[index];
          final isMore = index == 9;
          return InkWell(
            onTap: () => context.push(
              isMore ? '/category/${item.id}' : '/category/${item.id}',
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isMore)
                  Image.asset('assets/media/more.png', width: 32, height: 32)
                else
                  NetworkImageView(url: item.image, width: 40, height: 40),
                const SizedBox(height: 6),
                Text(
                  isMore ? '更多' : item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.item, required this.onTap});

  final LeaderboardItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xfff6f6f6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff404040),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 105,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (item.images.length > 1)
                    Positioned(
                      left: 8,
                      child: NetworkImageView(
                        url: item.images[1],
                        height: 78,
                        width: 58,
                      ),
                    ),
                  if (item.images.length > 2)
                    Positioned(
                      right: 8,
                      child: NetworkImageView(
                        url: item.images[2],
                        height: 78,
                        width: 58,
                      ),
                    ),
                  if (item.images.isNotEmpty)
                    NetworkImageView(
                      url: item.images.first,
                      height: 100,
                      width: 74,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
