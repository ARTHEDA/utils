import 'package:flutter_svg/flutter_svg.dart';
import 'package:utils/api/types.dart';

Future<void> precacheIcons(List<String> assets, {String? packageName}) async {
  Future<void> precacheSvgPicture(String asset) async {
    await safe(() async {
      final loader = SvgAssetLoader(asset, packageName: packageName);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    });
  }

  await Future.wait(assets.map(precacheSvgPicture));
}
