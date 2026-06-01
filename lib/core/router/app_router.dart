import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/audio_books/bloc/audio_book_bloc.dart';
import '../../features/audio_books/data/audio_book_repository.dart';
import '../../features/audio_books/view/audio_books_page.dart';
import '../../features/book_lists/bloc/book_list_bloc.dart';
import '../../features/book_lists/data/book_list_repository.dart';
import '../../features/book_lists/view/find_book_list_page.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/view/home_page.dart';
import '../network/api_client.dart';

GoRouter createRouter(ApiClient apiClient) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/home'),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  HomeBloc(HomeRepository(apiClient))..add(const HomeStarted()),
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/find-book-lists',
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  BookListBloc(BookListRepository(apiClient))
                    ..add(const BookListStarted()),
              child: const FindBookListPage(),
            ),
          ),
          GoRoute(
            path: '/audio-books',
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  AudioBookBloc(AudioBookRepository(apiClient))
                    ..add(const AudioBookStarted()),
              child: const AudioBooksPage(),
            ),
          ),
          GoRoute(
            path: '/me',
            builder: (context, state) =>
                const PlaceholderPage(title: '我', id: '待迁移'),
          ),
        ],
      ),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) => PlaceholderPage(
          title: '绘本详情',
          id: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/book-list/:id',
        builder: (context, state) => PlaceholderPage(
          title: '书单详情',
          id: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) =>
            PlaceholderPage(title: '分类', id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/rank/:id',
        builder: (context, state) =>
            PlaceholderPage(title: '榜单', id: state.pathParameters['id'] ?? ''),
      ),
    ],
  );
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem('找绘本', '/home', 'HomePage_on.png', 'HomePage_off.png'),
    _TabItem(
      '找书单',
      '/find-book-lists',
      'FindBookListPage_on.png',
      'FindBookListPage_off.png',
    ),
    _TabItem(
      '听故事',
      '/audio-books',
      'BookListPage_on.png',
      'BookListPage_off.png',
    ),
    _TabItem('我', '/me', 'LoginPage_on.png', 'LoginPage_off.png'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.path));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    return Scaffold(
      backgroundColor: const Color(0xfffcfcfc),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        onDestinationSelected: (index) => context.go(_tabs[index].path),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Image.asset(
                'assets/media/${tab.offIcon}',
                width: 30,
                height: 30,
              ),
              selectedIcon: Image.asset(
                'assets/media/${tab.onIcon}',
                width: 30,
                height: 30,
              ),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.id});

  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('ID: $id'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.label, this.path, this.onIcon, this.offIcon);

  final String label;
  final String path;
  final String onIcon;
  final String offIcon;
}
