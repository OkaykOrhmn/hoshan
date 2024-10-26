// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';
import 'package:hoshan/data/model/ai/chats_history_model.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/data/model/ai/send_message_model.dart';
import 'package:hoshan/ui/screens/home/chat/bloc/related_questions_bloc.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/screens/home/library/bloc/chats_history_bloc.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_bloc.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_event.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_state.dart';
import 'package:hoshan/ui/widgets/components/chat/cubit/like_message_cubit.dart';
import 'package:hoshan/ui/widgets/components/dialog/dialog_handler.dart';
import 'package:hoshan/ui/widgets/components/dropdown/cubit/all_bots_cubit.dart';
import 'package:hoshan/ui/widgets/components/snackbar/snackbar_handler.dart';
import 'package:hoshan/ui/widgets/sections/loading/default_placeholder.dart';

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
  late String messageCopy = messages.content ?? '';
  final GlobalKey _containerKey = GlobalKey();

  late Messages messages = widget.message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            messages.fromBot! ? 16 : 32, 0, messages.fromBot! ? 32 : 16, 16),
        child: Column(
          children: [
            InkWell(
              onLongPress: () {
                _showMorePopupMenu(context);
              },
              child: Container(
                  key: _containerKey, // Assign the key to the Container

                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: messages.fromBot!
                        ? Colors.white
                        : AppColors.primaryColor.defaultShade,
                    borderRadius: BorderRadius.circular(10).copyWith(
                        topRight: Radius.circular(messages.fromBot! ? 10 : 0),
                        bottomLeft:
                            Radius.circular(messages.fromBot! ? 0 : 10)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: messages.fromBot! && messages.id == null
                      ? BlocProvider(
                          create: (context) => SendMessageBloc()
                            ..add(SendMessageRequest(
                                request: SendMessageModel(
                                    botId: HomeCubit.bot!.id,
                                    model: HomeCubit.bot!.name,
                                    id: HomeCubit.chatId.value != -1 &&
                                            HomeCubit.chatId.value != -2
                                        ? HomeCubit.chatId.value
                                        : null,
                                    query: messages.content))),
                          child:
                              BlocConsumer<SendMessageBloc, SendMessageState>(
                            listener: (context, state) {
                              if (state is SendMessageSuccess) {
                                if (state.model.chatId != null) {
                                  if (HomeCubit.chatId.value == -1 ||
                                      HomeCubit.chatId.value == -2) {
                                    HomeCubit.chatId.value = state.model.chatId;
                                    context.read<ChatsHistoryBloc>().add(
                                        AddChat(
                                            chats: Chats(
                                                bot: HomeCubit.bot,
                                                createdAt: DateTime.now()
                                                    .toIso8601String(),
                                                id: state.model.chatId,
                                                title: state.model.chatTitle ??
                                                    'new')));
                                  }
                                }
                                if (state.model.humanMessageId != null) {
                                  context.read<HomeCubit>().changeHumanItemId(
                                      state.model.humanMessageId);
                                  context.read<RelatedQuestionsBloc>().add(
                                      GetAllRelatedQuestions(
                                          chatId: HomeCubit.chatId.value!,
                                          messageId:
                                              state.model.humanMessageId!,
                                          content: messages.content!));
                                }
                                if (state.model.aiMessageId != null) {
                                  messages = context
                                      .read<HomeCubit>()
                                      .changeItem(
                                          messages,
                                          messages.copyWith(
                                              id: state.model.aiMessageId,
                                              content: state.response));
                                }

                                if (state.model.content != null) {
                                  messageCopy = state.model.content!;
                                }
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Text(
                                    state is SendMessageLoading
                                        ? state.response
                                        : state is SendMessageSuccess
                                            ? state.response
                                            : '',
                                    style: AppTextStyles.body4.copyWith(
                                        color: AppColors.black.defaultShade),
                                  ),
                                  state is SendMessageSuccess
                                      ? messageActions()
                                      : SpinKitThreeBounce(
                                          size: 18,
                                          color: AppColors
                                              .primaryColor.defaultShade,
                                        )
                                ],
                              );
                            },
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Text(
                                messages.content ?? '',
                                style: AppTextStyles.body4.copyWith(
                                    color: messages.fromBot!
                                        ? AppColors.black.defaultShade
                                        : Colors.white),
                              ),
                            ),
                            messageActions()
                          ],
                        )),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: messages.fromBot!
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

  void _showMorePopupMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox containerRenderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;

    final Offset containerPosition =
        containerRenderBox.localToGlobal(Offset.zero);
    final Size containerSize = containerRenderBox.size;

    await showMenu<int>(
      context: context,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: !(messages.fromBot!)
          ? AppColors.primaryColor.defaultShade
          : Colors.white,
      position: RelativeRect.fromLTRB(
          containerPosition.dx,
          containerPosition.dy +
              containerSize.height +
              8, // Position below the container
          overlay.size.width - containerPosition.dx,
          overlay.size.height - containerPosition.dy - containerSize.height),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: morePopUpItem(icon: Assets.icon.outline.copy, title: 'کپی'),
        ),
        if (!messages.fromBot!)
          PopupMenuItem<int>(
            value: 1,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.share_rounded,
                        size: 16,
                        color: messages.fromBot!
                            ? AppColors.primaryColor.defaultShade
                            : Colors.white),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'اشتراک گذاری',
                      style: AppTextStyles.body4.copyWith(
                          color: messages.fromBot!
                              ? AppColors.primaryColor.defaultShade
                              : Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (messages.fromBot!)
          PopupMenuItem<int>(
            value: 2,
            child: morePopUpItem(
                icon: Assets.icon.outline.bitcoinRefresh, title: 'دوباره بپرس'),
          ),
        PopupMenuItem<int>(
          value: 3,
          child: morePopUpItem(icon: Assets.icon.outline.trash, title: 'حذف'),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 0:
            await Clipboard.setData(ClipboardData(text: messageCopy));
            Future.delayed(
                Duration.zero,
                () => SnackBarHandler(context)
                    .showInfo(message: 'متن کپی شد 😃', isTop: false));
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            await DialogHandler(context: context).showDeleteItem(
              title: 'پیام',
              onConfirm: () async {
                context.read<HomeCubit>().removeItem(messages);
              },
            );
            break;
          default:
        }
      }
    });
  }

  Directionality morePopUpItem(
      {required final SvgGenImage icon, required final String title}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            icon.svg(
                color: messages.fromBot!
                    ? AppColors.primaryColor.defaultShade
                    : Colors.white),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: AppTextStyles.body4.copyWith(
                  color: messages.fromBot!
                      ? AppColors.primaryColor.defaultShade
                      : Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Column messageActions() {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        if (messages.fromBot!)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              botsPopupMenu(),
              pencilPopupMenu(),
              BlocProvider<LikeMessageCubit>(
                create: (context) =>
                    LikeMessageCubit()..getLike(like: messages.like),
                child: BlocBuilder<LikeMessageCubit, LikeMessageState>(
                  builder: (context, state) {
                    return DefaultPlaceHolder(
                      enabled: state is LikeMessageLoading,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              await context.read<LikeMessageCubit>().setLike(
                                  like: state is LikeMessageDisLiked
                                      ? null
                                      : false,
                                  chatId: HomeCubit.chatId.value!,
                                  messageId: messages.id!);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: (state is LikeMessageDisLiked
                                        ? Assets.icon.bold.dislike
                                        : Assets.icon.outline.dislike)
                                    .svg(
                                        color: messages.fromBot!
                                            ? AppColors
                                                .primaryColor.defaultShade
                                            : Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await context.read<LikeMessageCubit>().setLike(
                                  like: state is LikeMessageLiked ? null : true,
                                  chatId: HomeCubit.chatId.value!,
                                  messageId: messages.id!);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: (state is LikeMessageLiked
                                        ? Assets.icon.bold.like
                                        : Assets.icon.outline.like)
                                    .svg(
                                        color: messages.fromBot!
                                            ? AppColors
                                                .primaryColor.defaultShade
                                            : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
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

  Widget botsPopupMenu() {
    return BlocBuilder<AllBotsCubit, AllBotsState>(
      builder: (context, state) {
        if (state is AllBotsSuccess) {
          return PopupMenuButton(
              offset: const Offset(0, 38),
              onSelected: (value) async {
                final list = context.read<HomeCubit>().state;
                context.read<HomeCubit>().clearItems();
                HomeCubit.bot = value;
                HomeCubit.chatId.value = -2;
                context.read<HomeCubit>().addItem(Messages(
                    content: list[list.length - 2].content, role: 'human'));
                context.read<HomeCubit>().addItem(Messages(
                    role: 'ai', content: list[list.length - 2].content));
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<Bots>>[
                  ...List.generate(
                    state.bots.length,
                    (index) => PopupMenuItem(
                        value: state.bots[index],
                        height: 46,
                        child: Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: CachedNetworkImage(
                                  imageUrl: state.bots[index].image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.bots[index].name!,
                                      style: AppTextStyles.body3.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  )
                ];
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleIconBtn(
                  icon: Assets.icon.outline.brain,
                  color: AppColors.primaryColor[50],
                  iconColor: AppColors.primaryColor.defaultShade,
                  size: 28,
                  iconPadding: const EdgeInsets.all(6),
                ),
              ));
        }
        return const SizedBox();
      },
    );
  }
}
