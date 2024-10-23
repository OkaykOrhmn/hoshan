// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/data/model/messages_model.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_bloc.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_state.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';

class ChatBubble extends StatefulWidget {
  final Messages message;
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.fromLTRB(widget.message.fromBot! ? 16 : 32, 0,
            widget.message.fromBot! ? 32 : 16, 16),
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: widget.message.fromBot!
                    ? Colors.white
                    : AppColors.primaryColor.defaultShade,
                borderRadius: BorderRadius.circular(10).copyWith(
                    topRight: Radius.circular(widget.message.fromBot! ? 10 : 0),
                    bottomLeft:
                        Radius.circular(widget.message.fromBot! ? 0 : 10)),
              ),
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<SendMessageBloc, SendMessageState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Text(
                          state is SendMessageSuccess
                              ? state.message
                              : state is SendMessageLoading
                                  ? state.message
                                  : 'Error',
                          style: AppTextStyles.body4.copyWith(
                              color: widget.message.fromBot!
                                  ? AppColors.black.defaultShade
                                  : Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      state is SendMessageLoading
                          ? Center(
                              child: SpinKitThreeBounce(
                                color: AppColors.primaryColor.defaultShade,
                                size: 32,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.message.fromBot!
                                    ? Expanded(child: botsPopupMenu())
                                    : const SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget.message.fromBot!)
                                      Row(
                                        children: [
                                          pencilPopupMenu(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Assets
                                                .icon.outline.bitcoinRefresh
                                                .svg(
                                                    color:
                                                        widget.message.fromBot!
                                                            ? AppColors
                                                                .primaryColor
                                                                .defaultShade
                                                            : Colors.white),
                                          ),
                                        ],
                                      ),
                                    if (!widget.message.fromBot!)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Icon(Icons.share_rounded,
                                            size: 16,
                                            color: widget.message.fromBot!
                                                ? AppColors
                                                    .primaryColor.defaultShade
                                                : Colors.white),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Assets.icon.outline.copy.svg(
                                          color: widget.message.fromBot!
                                              ? AppColors
                                                  .primaryColor.defaultShade
                                              : Colors.white),
                                    ),
                                    if (widget.message.fromBot!)
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Assets.icon.outline.dislike
                                                .svg(
                                                    color:
                                                        widget.message.fromBot!
                                                            ? AppColors
                                                                .primaryColor
                                                                .defaultShade
                                                            : Colors.white),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Assets.icon.outline.like.svg(
                                                color: widget.message.fromBot!
                                                    ? AppColors.primaryColor
                                                        .defaultShade
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: widget.message.fromBot!
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  '16:27',
                  style:
                      AppTextStyles.body5.copyWith(color: AppColors.black[400]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> pencilPopupMenu() {
    return PopupMenuButton(
        offset: const Offset(0, 38),
        onSelected: (value) async {},
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            ...List.generate(
              4,
              (index) => PopupMenuItem(
                value: index,
                height: 32,
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(index.toString())),
              ),
            )
          ];
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CircleIconBtn(
            icon: Assets.icon.outline.magicpen,
            color: AppColors.primaryColor[50],
            iconColor: AppColors.primaryColor.defaultShade,
            size: 28,
            iconPadding: const EdgeInsets.all(6),
          ),
        ));
  }

  PopupMenuButton<dynamic> botsPopupMenu() {
    return PopupMenuButton(
        offset: const Offset(0, 38),
        onSelected: (value) async {},
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            ...List.generate(
              4,
              (index) => PopupMenuItem(
                value: index,
                height: 32,
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(index.toString())),
              ),
            )
          ];
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          constraints: const BoxConstraints(maxWidth: 120),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryColor.defaultShade)),
          child: Row(
            children: [
              const Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    'از Perplexity بپرس',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Transform.rotate(
                angle: 90 * pi / 180,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                ),
              ),
            ],
          ),
        ));
  }
}
