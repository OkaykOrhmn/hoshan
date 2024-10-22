import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/text.dart';

class EmptyScreen extends StatelessWidget {
  final SvgGenImage image;
  final String title;
  final double? width;
  final double? height;
  const EmptyScreen(
      {super.key,
      required this.image,
      required this.title,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: SizedBox(width: width, height: height, child: image.svg())),
        const SizedBox(
          height: 48,
        ),
        Text(
          title,
          style: AppTextStyles.headline5,
        ),
        const SizedBox(
          height: 12,
        ),
        Assets.image.empty.emptyTextUnderline.svg()
      ],
    );
  }
}
