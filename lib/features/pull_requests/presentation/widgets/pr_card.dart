import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/pull_request.dart';

class PrCard extends StatefulWidget {
  final PullRequestModel pr;
  final int index;

  const PrCard({
    super.key,
    required this.pr,
    this.index = 0,
  });

  @override
  State<PrCard> createState() => _PrCardState();
}

class _PrCardState extends State<PrCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Staggered animation based on index
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openPr() async {
    final uri = Uri.parse(widget.pr.htmlUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _openPr,
            child: AnimatedContainer(
              duration: AppConstants.shortAnimation,
              margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: _isHovered ? AppTheme.surface : AppTheme.card,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                border: Border.all(
                  color: _isHovered ? AppTheme.primary.withValues(alpha: 0.5) : AppTheme.border,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Repository name row
                    Row(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.pr.repository.fullName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Time ago
                        Text(
                          timeago.format(widget.pr.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.smallPadding),

                    // PR title row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PR icon
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Icon(
                            widget.pr.draft
                                ? Icons.edit_document
                                : Icons.merge_rounded,
                            size: 16,
                            color: widget.pr.draft
                                ? AppTheme.textMuted
                                : AppTheme.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Title and number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.pr.title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: _isHovered
                                                ? AppTheme.primary
                                                : AppTheme.textPrimary,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' #${widget.pr.number}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppTheme.textMuted,
                                          ),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.smallPadding + 4),

                    // Author and labels row
                    Row(
                      children: [
                        // Author avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppConstants.smallAvatarSize / 2),
                          child: CachedNetworkImage(
                            imageUrl: widget.pr.author.avatarUrl,
                            width: AppConstants.smallAvatarSize,
                            height: AppConstants.smallAvatarSize,
                            placeholder: (context, url) => Container(
                              width: AppConstants.smallAvatarSize,
                              height: AppConstants.smallAvatarSize,
                              color: AppTheme.surface,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: AppConstants.smallAvatarSize,
                              height: AppConstants.smallAvatarSize,
                              color: AppTheme.surface,
                              child: const Icon(Icons.person, size: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.pr.author.login,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        // Draft badge
                        if (widget.pr.draft) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Text(
                              'Draft',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],

                        const Spacer(),

                        // Labels
                        if (widget.pr.labels.isNotEmpty)
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.pr.labels.take(3).map((label) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: _LabelChip(label: label),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final LabelModel label;

  const _LabelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: label.backgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: label.backgroundColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        label.name,
        style: TextStyle(
          color: label.backgroundColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
