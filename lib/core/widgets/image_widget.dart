import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;

  const ImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (image.endsWith('.svg')) {
      return SvgPicture.asset(
        image,
        height: height,
        width: width,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        fit: fit,
      );
    } else if (image.startsWith('http') || image.startsWith('https')) {
      return Image.network(
        image,
        height: height,
        width: width,
        color: color,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const SizedBox(), 
      );
    } else {
      return Image.asset(
        image,
        height: height,
        width: width,
        color: color,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }
  }
}
