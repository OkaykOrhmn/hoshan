import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/ui/theme/colors.dart';

class ImageNetwork extends StatelessWidget {
  final String url;
  final double aspectRatio;
  final double radius;
  const ImageNetwork(
      {super.key,
      required this.url,
      this.aspectRatio = 16 / 9,
      this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          httpHeaders: {
            'Authorization': "Bearer ${DioService.token}",
          },
          imageUrl: url,
          placeholder: (context, url) => placeholderView(),
          errorWidget: (context, url, error) {
            if (kDebugMode) {
              print("Catch image with Url: $url Failed Error: $error");
            }
            return placeholderView(
              child: Center(
                child: Icon(
                  Icons.image_not_supported_rounded,
                  size: 60,
                  color: AppColors.primaryColor.defaultShade,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget placeholderView({final Widget? child}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(color: AppColors.gray[100]),
      child: child,
    );
  }
}
