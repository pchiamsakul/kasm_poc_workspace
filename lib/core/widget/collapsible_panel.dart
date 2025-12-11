import 'package:flutter/material.dart';
import 'dart:async';

class CollapsiblePanel extends StatefulWidget {
  final Widget header;
  final Widget body;
  final Stream<bool>? expansionStream;
  final bool initiallyExpanded;

  const CollapsiblePanel({
    Key? key,
    required this.header,
    required this.body,
    this.expansionStream,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  CollapsiblePanelState createState() => CollapsiblePanelState();
}

class CollapsiblePanelState extends State<CollapsiblePanel> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  StreamSubscription<bool>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Set initial animation state
    if (_isExpanded) {
      _controller.value = 1.0;
    }

    // Listen to expansion stream if provided
    if (widget.expansionStream != null) {
      _streamSubscription = widget.expansionStream!.listen((shouldExpand) {
        _setExpansionState(shouldExpand);
      });
    }
  }

  void _setExpansionState(bool shouldExpand) {
    if (_isExpanded != shouldExpand) {
      setState(() {
        if (shouldExpand) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        _isExpanded = shouldExpand;
      });
    }
  }

  // Method to toggle expansion
  void _toggleExpand() {
    _setExpansionState(!_isExpanded);
  }

  // Method to programmatically expand the panel
  void expand() {
    _setExpansionState(true);
  }

  // Method to programmatically collapse the panel
  void collapse() {
    _setExpansionState(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand, // Tap to toggle expansion
      child: Column(
        children: [
          widget.header, // Custom header passed to the widget
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: _isExpanded ? null : 0, // Height 0 when collapsed
              child: FadeTransition(
                opacity: _animation,
                child: widget.body, // Custom body passed to the widget
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
