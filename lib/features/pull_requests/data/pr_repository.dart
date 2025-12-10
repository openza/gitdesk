import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../auth/data/token_repository.dart';
import '../domain/models/pull_request.dart';

final prRepositoryProvider = Provider<PrRepository>((ref) {
  final tokenRepo = ref.watch(tokenRepositoryProvider);
  return PrRepository(tokenRepo);
});

class PrRepository {
  final TokenRepository _tokenRepository;

  PrRepository(this._tokenRepository);

  Future<List<PullRequestModel>> getReviewRequests() async {
    final token = await _tokenRepository.getToken();
    final username = await _tokenRepository.getUsername();

    if (token == null || username == null) {
      throw Exception('Not authenticated');
    }

    final query = 'type:pr state:open review-requested:$username';
    final uri = Uri.parse(
      '${AppConstants.githubApiBaseUrl}/search/issues?q=${Uri.encodeComponent(query)}&sort=updated&order=desc&per_page=100',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];

      return items
          .map((item) =>
              PullRequestModel.fromGitHubIssue(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please check your token.');
    } else if (response.statusCode == 403) {
      final remaining = response.headers['x-ratelimit-remaining'];
      if (remaining == '0') {
        final resetTime = response.headers['x-ratelimit-reset'];
        throw Exception(
            'Rate limit exceeded. Resets at ${_formatResetTime(resetTime)}');
      }
      throw Exception('Access forbidden');
    } else {
      throw Exception('Failed to fetch pull requests: ${response.statusCode}');
    }
  }

  String _formatResetTime(String? resetTimestamp) {
    if (resetTimestamp == null) return 'unknown';
    final timestamp = int.tryParse(resetTimestamp);
    if (timestamp == null) return 'unknown';
    final resetDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${resetDate.hour}:${resetDate.minute.toString().padLeft(2, '0')}';
  }
}
