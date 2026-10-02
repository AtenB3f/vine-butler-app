import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class AppImagePage extends StatefulWidget {
  final AppImagePageViewState viewState;

  const AppImagePage({
    super.key,
    required this.viewState,
  });

  @override
  State<AppImagePage> createState() => _AppImagePageState();
}

class _AppImagePageState extends State<AppImagePage> {
  static const Duration _duration = Duration(milliseconds: 250);
  static const Duration _hoverDuration = Duration(milliseconds: 200);
  static const Curve _curve = Curves.easeInOut;
  static const double _edgeWidth = 80;
  static const Color _edgeShadow = Color(0x80000000);
  static const Color _edgeClear = Color(0x00000000);

  final PageController _pageController = PageController();
  final ValueNotifier<int> _index = ValueNotifier(0);

  AppIndicatorViewState? _indicatorViewState;
  bool _isLeftHovered = false;
  bool _isRightHovered = false;

  int get _count => widget.viewState.images.length;

  @override
  void initState() {
    super.initState();
    _syncIndicator();
  }

  @override
  void didUpdateWidget(covariant AppImagePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewState.images.length != _count) {
      _index.value = _index.value.clamp(0, math.max(_count - 1, 0));
      _syncIndicator();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _index.dispose();
    super.dispose();
  }

  void _syncIndicator() {
    _indicatorViewState = _count == 0 ? null : AppIndicatorViewState(total: _count, index: _index);
  }

  @override
  Widget build(BuildContext context) {
    final indicator = _indicatorViewState;

    return Column(
      spacing: context.isDesktop ? 10 : 6,
      children: [
        Expanded(child: _imageArea(context)),
        if (indicator != null) AppIndicator(viewState: indicator),
      ],
    );
  }

  Widget _imageArea(BuildContext context) {
    final images = widget.viewState.images;
    if (images.isEmpty) {
      return const SizedBox.expand(child: ColoredBox(color: BaseColor.light));
    }

    final pages = PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (index) => _index.value = index,
      itemBuilder: (context, index) => _page(images[index]),
    );

    if (!context.isDesktop) {
      return pages;
    }

    return Stack(
      children: [
        Positioned.fill(child: pages),
        Positioned.fill(
          child: ValueListenableBuilder<int>(
            valueListenable: _index,
            builder: (context, index, child) => _edges(index),
          ),
        ),
      ],
    );
  }

  Widget _page(ImageProvider image) {
    return Image(
      image: image,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return const ColoredBox(color: BaseColor.light);
      },
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: BaseColor.light,
        child: Center(child: AppIcons.imageLG(GrayColor.light)),
      ),
    );
  }

  Widget _edges(int index) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _edgeWidth,
          child: _edge(
            isLeft: true,
            isEnabled: index > 0,
            isHovered: _isLeftHovered,
            onHover: (value) => setState(() => _isLeftHovered = value),
            onTap: () => _pageController.previousPage(duration: _duration, curve: _curve),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: _edgeWidth,
          child: _edge(
            isLeft: false,
            isEnabled: index < _count - 1,
            isHovered: _isRightHovered,
            onHover: (value) => setState(() => _isRightHovered = value),
            onTap: () => _pageController.nextPage(duration: _duration, curve: _curve),
          ),
        ),
      ],
    );
  }

  Widget _edge({
    required bool isLeft,
    required bool isEnabled,
    required bool isHovered,
    required ValueChanged<bool> onHover,
    required VoidCallback onTap,
  }) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedOpacity(
            duration: _hoverDuration,
            curve: _curve,
            opacity: isHovered && isEnabled ? 1 : 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                  colors: const [_edgeShadow, _edgeClear],
                ),
              ),
              child: Align(
                alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isLeft ? AppIcons.chevronLeftLG(StateColor.white) : AppIcons.chevronRightLG(StateColor.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
