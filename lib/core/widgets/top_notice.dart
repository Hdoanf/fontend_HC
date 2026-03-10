import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum TopNoticeType { info, success, error }

OverlayEntry? _activeTopNotice;

void showTopNotice({
  required BuildContext context,
  required String message,
  TopNoticeType type = TopNoticeType.info,
}) {
  _activeTopNotice?.remove();

  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _TopNoticeCard(
      message: message,
      type: type,
      onDismissed: () {
        if (entry.mounted) {
          entry.remove();
        }
        if (identical(_activeTopNotice, entry)) {
          _activeTopNotice = null;
        }
      },
    ),
  );

  _activeTopNotice = entry;
  overlay.insert(entry);
}

class _TopNoticeCard extends StatefulWidget {
  const _TopNoticeCard({
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  final String message;
  final TopNoticeType type;
  final VoidCallback onDismissed;

  @override
  State<_TopNoticeCard> createState() => _TopNoticeCardState();
}

class _TopNoticeCardState extends State<_TopNoticeCard> {
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _visible = true;
      });
    });
    _timer = Timer(const Duration(seconds: 4), _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(widget.type);
    final icon = _icon(widget.type);

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            offset: _visible ? Offset.zero : const Offset(0, -0.15),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _visible ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, accent.withValues(alpha: 0.08)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: accent.withValues(alpha: 0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(icon, color: accent, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _dismiss,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss() {
    if (!_visible) {
      widget.onDismissed();
      return;
    }

    _timer?.cancel();
    setState(() {
      _visible = false;
    });
    Future<void>.delayed(const Duration(milliseconds: 180), widget.onDismissed);
  }
}

Color _accentColor(TopNoticeType type) {
  switch (type) {
    case TopNoticeType.info:
      return AppColors.primary;
    case TopNoticeType.success:
      return AppColors.success;
    case TopNoticeType.error:
      return AppColors.error;
  }
}

IconData _icon(TopNoticeType type) {
  switch (type) {
    case TopNoticeType.info:
      return Icons.info_outline_rounded;
    case TopNoticeType.success:
      return Icons.check_circle_outline_rounded;
    case TopNoticeType.error:
      return Icons.error_outline_rounded;
  }
}
