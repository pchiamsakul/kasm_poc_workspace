import 'package:flutter/widgets.dart';

import 'size_reporter_widget.dart';

class DynamicPageView extends StatefulWidget {
  final ValueChanged<int>? onChange;
  final PageController pageController;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final ScrollPhysics? physics;

  const DynamicPageView({
    super.key,
    this.onChange,
    required this.pageController,
    required this.itemBuilder,
    required this.itemCount,
    this.physics,
  });

  @override
  DynamicPageViewState createState() => DynamicPageViewState();
}

class DynamicPageViewState extends State<DynamicPageView> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late final List<double> _height = List.generate(widget.itemCount, (index) => 0.0).toList();

  late final _listener = () {
    final newPage = widget.pageController.page?.round() ?? 0;
    if (_currentPage != newPage) {
      setState(() => _currentPage = newPage);
    }
  };

  @override
  void initState() {
    widget.pageController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_listener);
    super.dispose();
  }

  double get _currentHeight => _height[_currentPage];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _currentHeight),
      duration: const Duration(milliseconds: 100),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView.builder(
        physics: widget.physics,
        onPageChanged: widget.onChange,
        controller: widget.pageController,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return OverflowBox(
              alignment: Alignment.topLeft,
              minHeight: 0,
              maxHeight: double.infinity,
              child: SizeReporterWidget(
                  child: widget.itemBuilder(context, index),
                  onSizeChange: (size) => setState(() => _height[index] = size.height)));
        },
      ),
    );
  }
}
