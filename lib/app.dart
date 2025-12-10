import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/token_screen.dart';
import 'features/pull_requests/presentation/screens/pr_list_screen.dart';

class GitDeskApp extends ConsumerWidget {
  const GitDeskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: authState.when(
        data: (isAuthenticated) {
          if (isAuthenticated) {
            return const PrListScreen();
          }
          return const TokenScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => const TokenScreen(),
      ),
    );
  }
}
