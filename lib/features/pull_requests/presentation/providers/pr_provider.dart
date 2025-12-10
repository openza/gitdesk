import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pr_repository.dart';
import '../../domain/models/pull_request.dart';

final prListProvider =
    AsyncNotifierProvider<PrListNotifier, List<PullRequestModel>>(() {
  return PrListNotifier();
});

class PrListNotifier extends AsyncNotifier<List<PullRequestModel>> {
  @override
  Future<List<PullRequestModel>> build() async {
    return _fetchPullRequests();
  }

  Future<List<PullRequestModel>> _fetchPullRequests() async {
    final prRepo = ref.read(prRepositoryProvider);
    return await prRepo.getReviewRequests();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPullRequests());
  }
}

// Provider for filtering/searching (future use)
final prSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered PR list based on search query
final filteredPrListProvider = Provider<AsyncValue<List<PullRequestModel>>>((ref) {
  final prList = ref.watch(prListProvider);
  final searchQuery = ref.watch(prSearchQueryProvider).toLowerCase();

  return prList.whenData((prs) {
    if (searchQuery.isEmpty) return prs;

    return prs.where((pr) {
      return pr.title.toLowerCase().contains(searchQuery) ||
          pr.repository.fullName.toLowerCase().contains(searchQuery) ||
          pr.author.login.toLowerCase().contains(searchQuery) ||
          pr.labels.any((l) => l.name.toLowerCase().contains(searchQuery));
    }).toList();
  });
});
