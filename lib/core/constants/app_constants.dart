class AppConstants {
  AppConstants._();

  static const String appName = 'GitDesk';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String tokenStorageKey = 'github_pat';
  static const String usernameStorageKey = 'github_username';

  // GitHub API
  static const String githubApiBaseUrl = 'https://api.github.com';

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 8.0;
  static const double avatarSize = 32.0;
  static const double smallAvatarSize = 20.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
