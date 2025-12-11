import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/constant/k_text_style.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class ToastUtils {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// Show a toast with custom message and type
  static void showToast(BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
    VoidCallback? onTap,
    bool isDismissible = true,
  }) {
    if (_isShowing) {
      hideToast();
    }

    _isShowing = true;
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) =>
          ToastWidget(
            message: message,
            type: type,
            title: title,
            onTap: onTap,
            onDismiss: hideToast,
            isDismissible: isDismissible,
          ),
    );

    overlay.insert(_overlayEntry!);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      hideToast();
    });
  }

  /// Show success toast
  static void showSuccess(BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.success,
      title: title ?? 'Success',
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show error toast
  static void showError(BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.error,
      title: title ?? 'Error',
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show warning toast
  static void showWarning(BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.warning,
      title: title ?? 'Warning',
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show info toast
  static void showInfo(BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    showToast(
      context,
      message: message,
      type: ToastType.info,
      title: title ?? 'Info',
      duration: duration,
      onTap: onTap,
    );
  }

  /// Hide current toast
  static void hideToast() {
    if (_isShowing && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final String? title;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool isDismissible;

  const ToastWidget({
    super.key,
    required this.message,
    required this.type,
    this.title,
    this.onTap,
    this.onDismiss,
    this.isDismissible = true,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return KColors.green;
      case ToastType.error:
        return KColors.pomegranate;
      case ToastType.warning:
        return KColors.equator;
      case ToastType.info:
        return KColors.blueRibbon;
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case ToastType.success:
        return KColors.white;
      case ToastType.error:
        return KColors.white;
      case ToastType.warning:
        return KColors.primaryDark;
      case ToastType.info:
        return KColors.white;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ToastType.success:
        return KColors.white;
      case ToastType.error:
        return KColors.white;
      case ToastType.warning:
        return KColors.primaryDark;
      case ToastType.info:
        return KColors.white;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  void _dismiss() async {
    await _animationController.reverse();
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery
          .of(context)
          .padding
          .top + 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                shadowColor: KColors.shadowColor,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: widget.isDismissible
                      ? Dismissible(
                    key: const Key('toast'),
                    direction: DismissDirection.up,
                    onDismissed: (_) => widget.onDismiss?.call(),
                    child: _buildToastContent(),
                  )
                      : _buildToastContent(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToastContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: KColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 24,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: KTextStyles.body4.copyWith(
                      color: _getTextColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                ],
                Text(
                  widget.message,
                  style: KTextStyles.caption1.copyWith(
                    color: _getTextColor(),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isDismissible) ...[
            const Gap(8),
            GestureDetector(
              onTap: _dismiss,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getTextColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  color: _getIconColor(),
                  size: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Extension to make it easier to use
extension ToastExtension on BuildContext {
  void showToast({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
    VoidCallback? onTap,
  }) {
    ToastUtils.showToast(
      this,
      message: message,
      type: type,
      duration: duration,
      title: title,
      onTap: onTap,
    );
  }

  void showSuccessToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    ToastUtils.showSuccess(
      this,
      message: message,
      title: title,
      duration: duration,
      onTap: onTap,
    );
  }

  void showErrorToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    ToastUtils.showError(
      this,
      message: message,
      title: title,
      duration: duration,
      onTap: onTap,
    );
  }

  void showWarningToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    ToastUtils.showWarning(
      this,
      message: message,
      title: title,
      duration: duration,
      onTap: onTap,
    );
  }

  void showInfoToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    ToastUtils.showInfo(
      this,
      message: message,
      title: title,
      duration: duration,
      onTap: onTap,
    );
  }
}