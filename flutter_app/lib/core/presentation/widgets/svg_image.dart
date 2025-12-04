import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  const SvgImage(
      {super.key,
      required this.asset,
      this.height,
      this.width,
      this.fit = BoxFit.contain,
      this.color});

  final String asset;
  final double? height;

  final Color? color;
  final double? width;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: height,
      width: width,
      fit: fit,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
