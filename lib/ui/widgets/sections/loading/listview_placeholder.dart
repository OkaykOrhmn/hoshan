import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class ListviewPlaceholder extends StatelessWidget {
  final int count;
  final double? itemWidth;
  final double? itemHeight;
  final Widget child;
  const ListviewPlaceholder(
      {super.key,
      this.count = 10,
      this.itemWidth,
      this.itemHeight,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Shimmer.fromColors(
              baseColor: AppColors.gray[400],
              highlightColor: AppColors.gray[600],
              child: child),
        );
      },
    );
  }
}
