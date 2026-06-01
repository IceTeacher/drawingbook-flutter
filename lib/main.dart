import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

import 'core/network/api_client.dart';
import 'core/router/app_router.dart';

void main() {
  JustAudioMediaKit.ensureInitialized();
  runApp(DrawingBookApp(apiClient: ApiClient()));
}

class DrawingBookApp extends StatelessWidget {
  DrawingBookApp({super.key, required ApiClient apiClient})
    : _router = createRouter(apiClient);

  final RouterConfig<Object> _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DrawingBook',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff5cd3b4),
          primary: const Color(0xff5cd3b4),
        ),
        scaffoldBackgroundColor: const Color(0xfffcfcfc),
        useMaterial3: true,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xff5cd3b4),
            foregroundColor: Colors.white,
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 14, color: Color(0xff666666)),
          ),
        ),
      ),
    );
  }
}
