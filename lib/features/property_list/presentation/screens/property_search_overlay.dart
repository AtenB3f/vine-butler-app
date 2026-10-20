import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class PropertySearchOverlay extends StatelessWidget {
  static const Duration _duration = Duration(milliseconds: 250);
  static const Curve _curve = Curves.easeInOut;

  final Widget child;
  final bool isVisible;
  final VoidCallback onDismiss;
  final List<Widget> searchResults;
  final Widget? filterPanel;

  const PropertySearchOverlay({
    super.key,
    required this.child,
    required this.isVisible,
    required this.onDismiss,
    this.searchResults = const [],
    this.filterPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedOpacity(
              duration: _duration,
              curve: _curve,
              opacity: isVisible ? 1 : 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDismiss,
                child: const ColoredBox(color: StateColor.overlay),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AnimatedSwitcher(
            duration: _duration,
            switchInCurve: _curve,
            switchOutCurve: _curve,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.topCenter,
              children: [...previousChildren, ?currentChild],
            ),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
            child: isVisible
                ? KeyedSubtree(key: const ValueKey('overlayPanel'), child: _overlayPanel())
                : const SizedBox.shrink(key: ValueKey('emptyPanel')),
          ),
        ),
      ],
    );
  }

  Widget _overlayPanel() {
    final filterPanel = this.filterPanel;

    return Container(
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.bottom],
      ),
      child: AnimatedSize(
        duration: _duration,
        curve: _curve,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (searchResults.isNotEmpty) _searchResults(),
            ?filterPanel,
          ],
        ),
      ),
    );
  }

  Widget _searchResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: StateColor.white,
        border: Border(bottom: BorderSide(color: BaseColor.light)),
      ),
      child: Column(children: searchResults),
    );
  }
}
