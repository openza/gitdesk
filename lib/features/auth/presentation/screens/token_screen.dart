import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class TokenScreen extends ConsumerStatefulWidget {
  const TokenScreen({super.key});

  @override
  ConsumerState<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends ConsumerState<TokenScreen> {
  final _tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureToken = true;
  String? _errorMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _submitToken() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authProvider.notifier).login(
          _tokenController.text.trim(),
        );

    if (!success && mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid token. Please check and try again.';
      });
    }
  }

  Future<void> _openTokenCreationPage() async {
    final uri = Uri.parse(
      'https://github.com/settings/tokens/new?description=GitDesk&scopes=repo,read:user',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App icon/logo
                  Icon(
                    Icons.inbox_rounded,
                    size: 64,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Title
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  // Subtitle
                  Text(
                    'GitHub PR Review Inbox',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.largePadding * 2),

                  // Token input
                  Text(
                    'Personal Access Token',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  TextFormField(
                    controller: _tokenController,
                    obscureText: _obscureToken,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      hintText: 'ghp_xxxxxxxxxxxxxxxxxxxx',
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureToken
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureToken = !_obscureToken;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your token';
                      }
                      if (!value.trim().startsWith('ghp_') &&
                          !value.trim().startsWith('github_pat_')) {
                        return 'Invalid token format';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submitToken(),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: AppTheme.error,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppConstants.defaultPadding),

                  // Submit button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitToken,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Connect to GitHub'),
                    ),
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  // Help text
                  Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Need a token?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          'Create a Personal Access Token with repo and read:user scopes.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        TextButton.icon(
                          onPressed: _openTokenCreationPage,
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: const Text('Create token on GitHub'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
