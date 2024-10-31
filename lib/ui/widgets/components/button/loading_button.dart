import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hoshan/ui/theme/colors.dart';

class LoadingButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final bool loading;
  final double? width;
  final double? height;
  final double radius;
  final Color? color;
  final bool isOutlined;
  const LoadingButton(
      {super.key,
      required this.child,
      this.onPressed,
      this.loading = false,
      this.width,
      this.height,
      this.color,
      this.radius = 12,
      this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: isOutlined
                      ? Colors.white
                      : color ?? AppColors.primaryColor[100],
                  shape: RoundedRectangleBorder(
                      side: isOutlined
                          ? BorderSide(
                              color: color ?? const Color(0xFF000000), width: 2)
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(radius))),
              onPressed: loading ? () {} : onPressed,
              child: Opacity(opacity: loading ? 0 : 1, child: child)),
        ),
        if (loading)
          Positioned.fill(
              child: Center(
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: height != null ? height! / 2 : 20,
            ),
          ))
      ],
    );
  }
}
