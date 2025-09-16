import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:utils/src/widgets/images/fullscreen_viewer.dart';
import 'package:utils/src/widgets/loaders/loading.dart';

class UrlImage extends StatelessWidget {
  const UrlImage(
    this.url, {
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.shape = BoxShape.rectangle,
  });

  Widget openable() {
    return Builder(
      builder: (context) {
        if (url == null) {
          return this;
        }
        return GestureDetector(
          onTap: () => FullscreenViewer.open(
            context: context,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Hero(
                tag: url!,
                child: Image.network(
                  url!,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
            closeWidget: const Icon(
              Icons.close_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
          child: Hero(
            tag: url!,
            child: this,
          ),
        );
      },
    );
  }

  final String? url;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        shape: shape,
      ),
      child: url == null
          ? errorWidget
          : ImageFade(
              image: NetworkImage(url!),
              fit: fit,
              syncDuration: Duration.zero,
              errorBuilder: (context, _) {
                return errorWidget ?? const SizedBox();
              },
              loadingBuilder: (context, _, __) {
                return const Center(child: Loading());
              },
            ),
    );
  }
}
