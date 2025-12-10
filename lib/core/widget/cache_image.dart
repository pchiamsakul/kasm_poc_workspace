import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends CachedNetworkImage {
  CachedImage(
    String? imageUrl, {
    super.key,
    super.httpHeaders,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration = null,
    super.fadeOutCurve,
    super.fadeInDuration = Duration.zero,
    super.fadeInCurve,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.repeat,
    super.matchTextDirection,
    super.useOldImageOnUrlChange,
    super.color,
    super.filterQuality,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    super.errorListener,
  }) : super(imageUrl: imageUrl ?? "");
}
