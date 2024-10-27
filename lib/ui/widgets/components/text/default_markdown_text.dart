import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/heading.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown.dart';

class DefaultMarkdownText extends StatelessWidget {
  final String text;
  final Color? color;
  const DefaultMarkdownText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MarkdownWidget(
        data: text,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        selectable: true,
        config: MarkdownConfig(configs: [
          H1Config(
              style: MarkdownConfig.defaultConfig.h1.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          H2Config(
              style: MarkdownConfig.defaultConfig.h2.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          H3Config(
              style: MarkdownConfig.defaultConfig.h3.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          H4Config(
              style: MarkdownConfig.defaultConfig.h4.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          H5Config(
              style: MarkdownConfig.defaultConfig.h5.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          H6Config(
              style: MarkdownConfig.defaultConfig.h6.style.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color)),
          PConfig(
              textStyle: MarkdownConfig.defaultConfig.p.textStyle.copyWith(
                  fontFamily: AppTextStyles.defaultFontFamily, color: color))
        ]),
      ),
    );
  }
}
