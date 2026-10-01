import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppToast extends StatelessWidget {
  final AppToastViewState viewState;
  final VoidCallback? onTap;

  const AppToast({
    super.key,
    required this.viewState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: StateColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [AppShadow.bottom],
      ),
      child: Row(
        spacing: 6,
        children: [
          _icon(),
          Expanded(
            child: AppFontStyle.body2.text(viewState.text, TextColor.dark),
          ),
          if (viewState.hasLink) AppIcons.arrowRightMD(TextColor.dark),
        ],
      ),
    );

    if (viewState.hasLink && onTap != null) {
      return Pressable(onTap: onTap!, child: content);
    }

    return content;
  }

  Widget _icon() {
    switch (viewState.type) {
      case AppToastType.check:
        return AppIcons.checkMD(TextColor.dark);
      case AppToastType.warning:
        return AppIcons.infoMD(TextColor.dark);
    }
  }
}

enum AppToastPosition {
  top,
  bottom
}

OverlayEntry? _toastEntry;

void _removeToast() {
  _toastEntry?.remove();
  _toastEntry = null;
}

void showAppToast(
  BuildContext context,
  AppToastViewState viewState, {
  VoidCallback? onTap,
  Duration duration = const Duration(seconds: 3),
  AppToastPosition position = AppToastPosition.bottom,
}) {
  _removeToast();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _ToastOverlay(
      viewState: viewState,
      onTap: onTap,
      duration: duration,
      position: position,
      onDismissed: () {
        if (identical(_toastEntry, entry)) {
          _removeToast();
        }
      },
    ),
  );

  _toastEntry = entry;
  Overlay.of(context).insert(entry);
}

class _ToastOverlay extends StatefulWidget {
  final AppToastViewState viewState;
  final VoidCallback? onTap;
  final Duration duration;
  final AppToastPosition position;
  final VoidCallback onDismissed;

  const _ToastOverlay({
    required this.viewState,
    required this.onTap,
    required this.duration,
    required this.position,
    required this.onDismissed,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> with SingleTickerProviderStateMixin {
  static const Duration _slideDuration = Duration(milliseconds: 400);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _slideDuration,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(0, widget.position == AppToastPosition.bottom ? 2 : -2),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.bounceIn,
    ),
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    final isBottom = widget.position == AppToastPosition.bottom;
    final onTap = widget.onTap;

    return Positioned(
      left: 16,
      right: 16,
      top: isBottom ? null : 16 + padding.top,
      bottom: isBottom ? 24 + padding.bottom : null,
      child: SlideTransition(
        position: _slide,
        child: Material(
          type: MaterialType.transparency,
          child: AppToast(
            viewState: widget.viewState,
            onTap: onTap == null
                ? null
                : () {
                    _dismiss();
                    onTap();
                  },
          ),
        ),
      ),
    );
  }
}
