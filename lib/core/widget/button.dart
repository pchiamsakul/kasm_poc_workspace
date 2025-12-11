import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/constant/k_text_style.dart';

class Button extends StatelessWidget {
  final String title;
  final double? elevation;
  final EdgeInsets? margin;
  final Function()? onPressed;
  final Color? color;
  final Color? shadowColor;
  final double? fontSize;
  final TextStyle? textStyle;
  final bool isEnabled;
  final bool fullSize;
  final EdgeInsets? padding;
  final bool isOutlined;
  final bool isShowShadow;
  final Widget? iconChild;

  const Button({
    super.key,
    required this.title,
    this.elevation,
    this.margin,
    required this.onPressed,
    this.color,
    this.isShowShadow = false,
    this.shadowColor,
    this.fontSize,
    this.textStyle,
    this.isEnabled = true,
    this.iconChild,
    this.fullSize = false,
    this.padding,
    this.isOutlined = false,
  });

  ButtonStyle get buttonStyle => isOutlined
      ? ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          backgroundColor: KColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: color ?? KColors.primary, width: 2),
          ),
          alignment: Alignment.center,
          elevation: elevation ?? 0,
        )
      : ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          backgroundColor: color ?? KColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          elevation: elevation ?? 0,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullSize ? MediaQuery.of(context).size.width : null,
      margin: margin,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.50),
        ),
        shadows: [
          if (isEnabled && isShowShadow)
            BoxShadow(
              color: shadowColor ?? KColors.primary.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            )
        ],
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconChild != null) iconChild!,
            Text(
              title,
              style: textStyle != null && !isOutlined
                  ? textStyle
                  : KTextStyles.h4.copyWith(
                      fontSize: fontSize ?? 16,
                      color: color ?? (isOutlined ? KColors.primary : KColors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
