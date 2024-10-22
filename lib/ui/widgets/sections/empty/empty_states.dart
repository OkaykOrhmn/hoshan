import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/widgets/sections/empty/empty_screen.dart';

class EmptyStates {
  static Widget inbox({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.inbox,
        title: 'صندوق پیام خالی است');
  }

  static Widget amount({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.amount,
        title: 'موجودی حساب کافی نیست');
  }

  static Widget server({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.server,
        title: 'سرور مشغول است');
  }

  static Widget connection({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.connection,
        title: 'اینترنت قطع است');
  }

  static Widget archive({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.archive,
        title: 'لیست آرشیو شده‌ها خالی است');
  }

  static Widget messages({final double? width, final double? height}) {
    return EmptyScreen(
        width: width,
        height: height,
        image: Assets.image.empty.message,
        title: 'لیست پیام‌ها خالی است');
  }
}
