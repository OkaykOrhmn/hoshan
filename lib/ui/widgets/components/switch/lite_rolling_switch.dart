// ignore_for_file: deprecated_member_use_from_same_package

library lite_rolling_switch;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiteRollingSwitch extends StatefulWidget {
  @required
  final bool value;
  final double width;
  final double heght;

  @required
  final Function(bool) onChanged;
  final String textOff;
  final Color textOffColor;
  final String textOn;
  final Color textOnColor;
  final Color colorOn;
  final Color colorOff;
  final double textSize;
  final Duration animationDuration;
  final Widget? iconOn;
  final Widget? iconOff;
  final Function()? onTap;
  final Function()? onDoubleTap;
  final Function()? onSwipe;

  const LiteRollingSwitch({
    super.key,
    this.value = false,
    this.width = 72,
    this.heght = 32,
    this.textOff = "Off",
    this.textOn = "On",
    this.textSize = 14.0,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff,
    this.iconOn,
    this.animationDuration = const Duration(milliseconds: 300),
    this.textOffColor = Colors.white,
    this.textOnColor = Colors.black,
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    required this.onChanged,
  });

  @override
  State<LiteRollingSwitch> createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<LiteRollingSwitch>
    with SingleTickerProviderStateMixin {
  /// Late declarations
  late AnimationController animationController;
  late Animation<double> animation;
  late bool turnState;

  double value = 0.0;

  @override
  void dispose() {
    //Ensure to dispose animation controller
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;

    // Executes a function only one time after the layout is completed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (turnState) {
          animationController.forward();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Color transition animation
    Color? transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onDoubleTap: () {
        _action();
        widget.onDoubleTap?.call();
      },
      onTap: () {
        _action();
        widget.onTap?.call();
      },
      onPanEnd: (details) {
        _action();
        widget.onSwipe?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(4).copyWith(left: 0),
        width: widget.width,
        height: widget.heght,
        decoration: BoxDecoration(
            color: transitionColor, borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * value, 0)
                  : Offset(10 * value, 0), //original
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Container(
                  padding: isRTL(context)
                      ? const EdgeInsets.only(left: 10)
                      : const EdgeInsets.only(right: 10),
                  alignment: isRTL(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  height: 40,
                  child: Text(
                    widget.textOff,
                    style: TextStyle(
                        color: widget.textOffColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.textSize),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset(-10 * (1 - value), 0)
                  : Offset(10 * (1 - value), 0), //original
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  padding: isRTL(context)
                      ? const EdgeInsets.only(right: 5)
                      : const EdgeInsets.only(left: 5),
                  alignment: isRTL(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    widget.textOn,
                    style: TextStyle(
                        color: widget.textOnColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.textSize),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: isRTL(context)
                  ? Offset((-widget.width + 50) * value, 0)
                  : Offset((widget.width - 40) * value, 0),
              child: Transform.rotate(
                angle: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: widget.iconOff ?? const SizedBox(),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: (value).clamp(0.0, 1.0),
                          child: widget.iconOn ?? const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

      widget.onChanged(turnState);
    });
  }
}

bool isRTL(BuildContext context) {
  return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}
