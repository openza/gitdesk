import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/pull_request.dart';
import '../providers/pr_provider.dart';
import '../widgets/pr_card.dart';

class PrListScreen extends ConsumerStatefulWidget {
  const PrListScreen({super.key});

  @override
  ConsumerState<PrListScreen> createState() => _PrListScreenState();
}

class _PrListScreenState extends ConsumerState<PrListScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);

    // Refresh both lists
    await Future.wait([
      ref.read(prListProvider.notifier).refresh(),
      ref.read(createdPrListProvider.notifier).refresh(),
    ]);

    setState(() => _isRefreshing = false);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(currentUsernameProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                // App icon
                Icon(
                  Icons.inbox_rounded,
                  color: AppTheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: AppTheme.textSecondary,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.all(4),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    tabs: const [
                      Tab(
                        height: 32,
                        text: 'Review Requests',
                      ),
                      Tab(
                        height: 32,
                        text: 'Created',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Search field
                SizedBox(
                  width: 220,
                  height: 36,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      ref.read(prSearchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      filled: true,
                      fillColor: AppTheme.card,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Refresh button
                IconButton(
                  onPressed: _isRefreshing ? null : _refresh,
                  icon: _isRefreshing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                ),

                // User menu
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppTheme.border),
                  ),
                  color: AppTheme.surface,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        username.when(
                          data: (name) => Text(
                            name ?? 'User',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          loading: () => const Text('...'),
                          error: (e, s) => const Text('User'),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.expand_more,
                          size: 18,
                          color: AppTheme.textMuted,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: AppTheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sign out',
                            style: TextStyle(color: AppTheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog();
                    }
                  },
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Review Requests tab
                _buildPrList(
                  ref.watch(filteredPrListProvider),
                  emptyMessage: 'No pull requests waiting for your review',
                  emptyIcon: Icons.check_circle_outline_rounded,
                ),
                // Created PRs tab
                _buildPrList(
                  ref.watch(filteredCreatedPrListProvider),
                  emptyMessage: 'You have no open pull requests',
                  emptyIcon: Icons.create_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrList(
    AsyncValue<List<PullRequestModel>> prList, {
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    return prList.when(
      data: (prs) {
        if (prs.isEmpty) {
          return _buildEmptyState(emptyMessage, emptyIcon);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: prs.length,
          itemBuilder: (context, index) {
            return PrCard(
              pr: prs[index],
              index: index,
            );
          },
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final searchQuery = ref.watch(prSearchQueryProvider);
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : icon,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            isSearching ? 'No matching pull requests' : 'All caught up!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            isSearching ? 'Try a different search term' : message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (isSearching) ...[
            const SizedBox(height: AppConstants.defaultPadding),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                ref.read(prSearchQueryProvider.notifier).state = '';
              },
              icon: const Icon(Icons.clear_rounded, size: 16),
              label: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Loading pull requests...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppTheme.error,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
