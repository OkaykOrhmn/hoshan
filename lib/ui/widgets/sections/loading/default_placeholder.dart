import 'package:flutter/cupertino.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class DefaultPlaceHolder extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final double? width;
  final double? height;
  const DefaultPlaceHolder(
      {super.key,
      required this.child,
      this.enabled = true,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return enabled
        ? SizedBox(
            width: width,
            height: height,
            child: Shimmer.fromColors(
                baseColor: AppColors.gray[400],
                highlightColor: AppColors.gray[600],
                child: child),
          )
        : child;
  }
}
