// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Prompt-Bold.ttf
  String get promptBold => 'assets/fonts/Prompt-Bold.ttf';

  /// File path: assets/fonts/Prompt-Regular.ttf
  String get promptRegular => 'assets/fonts/Prompt-Regular.ttf';

  /// List of all assets
  List<String> get values => [promptBold, promptRegular];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/default_remote_config.json
  String get defaultRemoteConfig => 'assets/json/default_remote_config.json';

  /// List of all assets
  List<String> get values => [defaultRemoteConfig];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/ic_add.svg
  SvgGenImage get icAdd => const SvgGenImage('assets/svg/ic_add.svg');

  /// File path: assets/svg/ic_alert.svg
  SvgGenImage get icAlert => const SvgGenImage('assets/svg/ic_alert.svg');

  /// File path: assets/svg/ic_calendar.svg
  SvgGenImage get icCalendar => const SvgGenImage('assets/svg/ic_calendar.svg');

  /// File path: assets/svg/ic_check.svg
  SvgGenImage get icCheck => const SvgGenImage('assets/svg/ic_check.svg');

  /// File path: assets/svg/ic_chevron_left.svg
  SvgGenImage get icChevronLeft =>
      const SvgGenImage('assets/svg/ic_chevron_left.svg');

  /// File path: assets/svg/ic_chevron_right.svg
  SvgGenImage get icChevronRight =>
      const SvgGenImage('assets/svg/ic_chevron_right.svg');

  /// File path: assets/svg/ic_close.svg
  SvgGenImage get icClose => const SvgGenImage('assets/svg/ic_close.svg');

  /// File path: assets/svg/ic_dialog_error.svg
  SvgGenImage get icDialogError =>
      const SvgGenImage('assets/svg/ic_dialog_error.svg');

  /// File path: assets/svg/ic_edit.svg
  SvgGenImage get icEdit => const SvgGenImage('assets/svg/ic_edit.svg');

  /// File path: assets/svg/ic_google.svg
  SvgGenImage get icGoogle => const SvgGenImage('assets/svg/ic_google.svg');

  /// File path: assets/svg/ic_info.svg
  SvgGenImage get icInfo => const SvgGenImage('assets/svg/ic_info.svg');

  /// File path: assets/svg/ic_manage.svg
  SvgGenImage get icManage => const SvgGenImage('assets/svg/ic_manage.svg');

  /// File path: assets/svg/ic_no_project_exist.svg
  SvgGenImage get icNoProjectExist =>
      const SvgGenImage('assets/svg/ic_no_project_exist.svg');

  /// File path: assets/svg/ic_project.svg
  SvgGenImage get icProject => const SvgGenImage('assets/svg/ic_project.svg');

  /// File path: assets/svg/ic_session_expired.svg
  SvgGenImage get icSessionExpired =>
      const SvgGenImage('assets/svg/ic_session_expired.svg');

  /// File path: assets/svg/ic_team.svg
  SvgGenImage get icTeam => const SvgGenImage('assets/svg/ic_team.svg');

  /// File path: assets/svg/ic_tick_circle.svg
  SvgGenImage get icTickCircle =>
      const SvgGenImage('assets/svg/ic_tick_circle.svg');

  /// File path: assets/svg/ic_time.svg
  SvgGenImage get icTime => const SvgGenImage('assets/svg/ic_time.svg');

  /// File path: assets/svg/il_assign_project.svg
  SvgGenImage get ilAssignProject =>
      const SvgGenImage('assets/svg/il_assign_project.svg');

  /// File path: assets/svg/il_empty.svg
  SvgGenImage get ilEmpty => const SvgGenImage('assets/svg/il_empty.svg');

  /// File path: assets/svg/il_empty_02.svg
  SvgGenImage get ilEmpty02 => const SvgGenImage('assets/svg/il_empty_02.svg');

  /// File path: assets/svg/il_error_occurred.svg
  SvgGenImage get ilErrorOccurred =>
      const SvgGenImage('assets/svg/il_error_occurred.svg');

  /// File path: assets/svg/logo_hops.svg
  SvgGenImage get logoHops => const SvgGenImage('assets/svg/logo_hops.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    icAdd,
    icAlert,
    icCalendar,
    icCheck,
    icChevronLeft,
    icChevronRight,
    icClose,
    icDialogError,
    icEdit,
    icGoogle,
    icInfo,
    icManage,
    icNoProjectExist,
    icProject,
    icSessionExpired,
    icTeam,
    icTickCircle,
    icTime,
    ilAssignProject,
    ilEmpty,
    ilEmpty02,
    ilErrorOccurred,
    logoHops,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const String develop = 'develop.env';
  static const String production = 'production.env';

  /// List of all assets
  static List<String> get values => [develop, production];
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
