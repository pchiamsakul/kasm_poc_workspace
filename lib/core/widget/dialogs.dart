import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/constant/k_text_style.dart';
import 'package:kasm_poc_workspace/core/widget/button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final DialogButtons? dialogButtons;
  final Widget? icon;
  final double? iconWidth;
  final double? iconHeight;
  final String? description;
  final Widget? descriptionWidget;

  const CustomAlertDialog({
    required this.title,
    required this.dialogButtons,
    this.description,
    this.icon,
    this.iconWidth,
    this.iconHeight,
    this.descriptionWidget,
    super.key,
  });

  factory CustomAlertDialog.defaultSingleButton({
    Key? key,
    required String title,
    String? description,
    required String defaultButtonText,
    required dynamic Function() defaultButtonCallback,
    Widget? icon,
    double? iconWidth,
    double? iconHeight,
    Widget? descriptionWidget,
  }) {
    return CustomAlertDialog(
      title: title,
      description: description,
      icon: icon,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      descriptionWidget: descriptionWidget,
      dialogButtons: DialogButtons(
        key: key,
        defaultButtonText: defaultButtonText,
        onDefaultButtonPressed: defaultButtonCallback,
      ),
    );
  }

  factory CustomAlertDialog.sideBySide({
    Key? key,
    required String title,
    String? description,
    required String defaultButtonText,
    Widget? descriptionWidget,
    required dynamic Function() defaultButtonCallback,
    required String secondaryButtonText,
    required dynamic Function() secondaryButtonCallback,
    bool stackHorizontally = true,
    Widget? icon,
    double? iconWidth,
    double? iconHeight,
  }) {
    return CustomAlertDialog(
      description: description,
      title: title,
      icon: icon,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      descriptionWidget: descriptionWidget,
      dialogButtons: DialogButtons(
        key: key,
        defaultButtonText: defaultButtonText,
        onDefaultButtonPressed: defaultButtonCallback,
        secondaryButtonText: secondaryButtonText,
        onSecondaryButtonPressed: secondaryButtonCallback,
        stackHorizontally: stackHorizontally,
      ),
    );
  }

  factory CustomAlertDialog.threePrimaryButtons({
    required String title,
    required String description,
    required String bottomButtonText,
    required dynamic Function() bottomButtonCallback,
    required String middleButtonText,
    required dynamic Function() middleButtonCallback,
    required String topButtonText,
    required dynamic Function() topButtonCallback,
    Widget? icon,
    double? iconWidth,
    double? iconHeight,
    Widget? descriptionWidget,
  }) {
    return CustomAlertDialog(
      description: description,
      title: title,
      icon: icon,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      descriptionWidget: descriptionWidget,
      dialogButtons: DialogButtons(
        defaultButtonText: topButtonText,
        onDefaultButtonPressed: topButtonCallback,
        secondaryButtonText: middleButtonText,
        onSecondaryButtonPressed: middleButtonCallback,
        tertiaryButtonText: bottomButtonText,
        onTertiaryButtonPressed: bottomButtonCallback,
        stackHorizontally: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      backgroundColor: KColors.white,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: iconWidth ?? 60,
                  height: iconHeight ?? 60,
                  child: icon,
                ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: KTextStyles.h3,
              ),
              const Gap(8),
              if (descriptionWidget != null)
                descriptionWidget ?? const SizedBox()
              else if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: KTextStyles.body3,
                ),
              const Gap(24),
              if (dialogButtons != null) dialogButtons!,
            ],
          ),
        ),
      ),
    );
  }
}

class DialogButtons extends StatelessWidget {
  final String? defaultButtonText;
  final String? secondaryButtonText;
  final String? tertiaryButtonText;
  final dynamic Function()? onDefaultButtonPressed;
  final dynamic Function()? onSecondaryButtonPressed;
  final dynamic Function()? onTertiaryButtonPressed;

  /// Default value will be stack horizontal way
  final bool stackHorizontally;

  DialogButtons({
    super.key,
    this.defaultButtonText,
    this.secondaryButtonText,
    this.tertiaryButtonText,
    this.onDefaultButtonPressed,
    this.onSecondaryButtonPressed,
    this.onTertiaryButtonPressed,
    this.stackHorizontally = true,
  }) {
    assert(defaultButtonText != null || secondaryButtonText != null || tertiaryButtonText != null,
        "At least 1 button text should be provided");
  }

  Widget rowOrColumn({required List<Widget> children}) => stackHorizontally
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        )
      : Column(children: children);

  Widget space() => stackHorizontally ? const Gap(8) : const Gap(12);

  Widget button({required Widget child}) => stackHorizontally ? Expanded(child: child) : child;

  @override
  Widget build(BuildContext context) {
    final showDefaultButton = defaultButtonText != null;
    final showSecondaryButton = secondaryButtonText != null;
    final showTertiaryButton = tertiaryButtonText != null;

    return rowOrColumn(
      children: [
        if (showSecondaryButton && stackHorizontally)
          button(
            child: Button(
              title: secondaryButtonText!,
              isEnabled: true,
              textStyle: KTextStyles.h4.copyWith(color: KColors.white),
              onPressed: () {
                final result = onSecondaryButtonPressed?.call();
                Navigator.pop(context, result);
              },
              isOutlined: true,
            ),
          ),
        if (showDefaultButton && showSecondaryButton && stackHorizontally) space(),
        if (showDefaultButton)
          button(
            child: Button(
              onPressed: () {
                final result = onDefaultButtonPressed?.call();
                Navigator.pop(context, result);
              },
              title: defaultButtonText!,
              isEnabled: true,
              textStyle: KTextStyles.h4.copyWith(color: KColors.white),
            ),
          ),
        if (showSecondaryButton && !stackHorizontally) ...[
          space(),
          button(
            child: Button(
              title: secondaryButtonText!,
              isEnabled: true,
              textStyle: KTextStyles.h4.copyWith(color: KColors.white),
              onPressed: () {
                final result = onSecondaryButtonPressed?.call();
                Navigator.pop(context, result);
              },
              isOutlined: true,
            ),
          )
        ],
        if (showSecondaryButton && showTertiaryButton) space(),
        if (showTertiaryButton)
          button(
            child: Button(
              title: tertiaryButtonText!,
              isEnabled: true,
              textStyle: KTextStyles.h4.copyWith(color: KColors.white),
              onPressed: () {
                final result = onTertiaryButtonPressed?.call();
                Navigator.pop(context, result);
              },
              isOutlined: true,
            ),
          ),
      ],
    );
  }
}
