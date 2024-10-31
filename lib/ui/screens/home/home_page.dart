// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/file_manager/pick_file_services.dart';
import 'package:hoshan/core/utils/file.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';
import 'package:hoshan/data/model/home_navbar_model.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';
import 'package:hoshan/ui/screens/home/chat/bloc/related_questions_bloc.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/screens/home/library/library_screen.dart';
import 'package:hoshan/ui/screens/home/chat/chat_screen.dart';
import 'package:hoshan/ui/screens/home/chat/home_chat_screen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/animations/animated_visibility.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_bloc.dart';
import 'package:hoshan/ui/widgets/components/dialog/bottom_sheets.dart';
import 'package:hoshan/ui/widgets/sections/empty/empty_states.dart';
import 'package:hoshan/ui/widgets/sections/header/home_appbar.dart';
import 'package:hoshan/ui/widgets/sections/loading/chat_screen_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> visibleAttach = ValueNotifier(false);
  final List<HomeNavbar> navIcons = [
    HomeNavbar(title: 'چت', icon: 'messages', enabled: true),
    HomeNavbar(title: 'جعبه ابزار', icon: 'tool-box', enabled: false),
    HomeNavbar(title: 'کتابخانه', icon: 'library', enabled: false),
    HomeNavbar(title: 'خبر', icon: 'news', enabled: false),
  ];

  final TextEditingController message = TextEditingController();

  PreferredSizeWidget? getAppBAr(int indexed) {
    PreferredSizeWidget? preferredSizeWidget;
    if (indexed == 0 || indexed == 1) {
      preferredSizeWidget = const HomeAppbar();
    }
    return preferredSizeWidget;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HomeCubit.indexed,
        builder: (context, indexed, _) {
          return WillPopScope(
            onWillPop: () async {
              if (indexed == 0) {
                if (HomeCubit.chatId.value != null) {
                  HomeCubit.chatId.value = null;
                  HomeCubit.bot.value = null;
                  context.read<HomeCubit>().clearItems();
                  ChatbotRepository.cancelToken?.cancel();
                  return false;
                } else {
                  return true;
                }
              } else {
                setState(() {
                  indexed = 0;
                });
                return false;
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: indexed == 0,
              appBar: getAppBAr(indexed),
              body: IndexedStack(
                index: indexed,
                children: [
                  ValueListenableBuilder(
                      valueListenable: HomeCubit.chatId,
                      builder: (context, val, _) {
                        return val != null
                            ? val == -3
                                ? EmptyStates.server()
                                : val == -1
                                    ? const ChatScreenPlaceholder()
                                    : const ChatScreen()
                            : const HomeChatScreen();
                      }),
                  EmptyStates.inbox(),
                  const LibraryScreen(),
                  EmptyStates.server(),
                ],
              ),
              bottomNavigationBar: homeBottomNavigationBar(),
              bottomSheet: indexed == 0 ? homeMessageBar() : null,
            ),
          );
        });
  }

  Widget homeMessageBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: HomeCubit.selectedFile,
          builder: (context, file, child) {
            if (file != null) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                margin: const EdgeInsets.all(16).copyWith(bottom: 0),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.defaultShade,
                    borderRadius: BorderRadius.circular(16)
                        .copyWith(topRight: Radius.zero)),
                child: Row(
                  children: [
                    CircleIconBtn(
                      icon: Assets.icon.outline.trash,
                      color: AppColors.secondryColor.defaultShade,
                      iconColor: Colors.white,
                      iconPadding: const EdgeInsets.all(6),
                      onTap: () {
                        HomeCubit.selectedFile.value = null;
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (file.isImage())
                      Expanded(
                          child: Text(
                        file.name,
                        style:
                            AppTextStyles.body4.copyWith(color: Colors.white),
                      )),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 46,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                              child: Image.file(
                            File(file.path),
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
        ValueListenableBuilder<Bots?>(
            valueListenable: HomeCubit.bot,
            builder: (context, value, _) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: message,
                            builder: (context, val, _) {
                              if (val.text.isEmpty) {
                                return CircleIconBtn(
                                  icon: Assets.icon.outline.microphoneChat,
                                  onTap: () {},
                                );
                              }
                              return CircleIconBtn(
                                icon: Assets.icon.bold.send,
                                onTap: () async {
                                  if (SendMessageBloc.onResponse.value) return;
                                  if (message.text.isNotEmpty &&
                                      HomeCubit.bot.value != null) {
                                    HomeCubit.chatId.value ??= -2;
                                    context.read<HomeCubit>().addItem(Messages(
                                        content: [Content(text: message.text)],
                                        role: 'human',
                                        file: HomeCubit.selectedFile.value));
                                    context.read<HomeCubit>().addItem(Messages(
                                          role: 'ai',
                                          content: [
                                            Content(text: message.text)
                                          ],
                                        ));

                                    message.clear();
                                    context
                                        .read<RelatedQuestionsBloc>()
                                        .add(ClearAllRelatedQuestions());
                                  }
                                },
                              );
                            }),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: TextField(
                          controller: message,
                          onChanged: (value) {},
                          enabled: value != null ||
                              (value != null &&
                                  value.attachment != 2 &&
                                  HomeCubit.selectedFile.value != null),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'چیزی بنویسید ...',
                            hintStyle: AppTextStyles.body4,
                            fillColor: AppColors.gray[400],
                            contentPadding:
                                const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        )),
                        const SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder(
                                valueListenable: visibleAttach,
                                builder: (context, isVisible, _) {
                                  return AnimatedVisibility(
                                      isVisible: isVisible,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: value != null &&
                                                value.attachment != 0
                                            ? Row(children: [
                                                if (value.attachmentType !=
                                                        null &&
                                                    value.attachmentType!
                                                        .contains('image'))
                                                  CircleIconBtn(
                                                      icon: Assets.icon.outline
                                                          .galleryAdd,
                                                      onTap: () async {
                                                        await BottomSheetHandler(
                                                                context)
                                                            .showPickImage(
                                                          onSelect: (file) {
                                                            HomeCubit
                                                                .selectedFile
                                                                .value = file;
                                                          },
                                                        );
                                                      }),
                                                if (value.attachmentType !=
                                                        null &&
                                                    value.attachmentType!
                                                        .contains('audio'))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: CircleIconBtn(
                                                      icon: Assets.icon.outline
                                                          .musicnote,
                                                      onTap: () async {
                                                        final file =
                                                            await PickFileService
                                                                .getFile(
                                                                    fileType:
                                                                        FileType
                                                                            .audio);
                                                        if (file != null) {
                                                          HomeCubit.selectedFile
                                                                  .value =
                                                              file.single;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                if (value.attachmentType !=
                                                        null &&
                                                    value.attachmentType!
                                                        .contains('file'))
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: CircleIconBtn(
                                                        icon: Assets.icon
                                                            .outline.cardAdd,
                                                        onTap: () async {
                                                          final file =
                                                              await PickFileService
                                                                  .getFile(
                                                                      fileType:
                                                                          FileType
                                                                              .any);
                                                          if (file != null) {
                                                            HomeCubit
                                                                    .selectedFile
                                                                    .value =
                                                                file.single;
                                                          }
                                                        }),
                                                  ),
                                              ])
                                            : const SizedBox(),
                                      ));
                                }),
                            if (value != null &&
                                value.attachment != 0 &&
                                value.attachmentType != null &&
                                value.attachmentType!.isNotEmpty)
                              CircleIconBtn(
                                icon: Assets.icon.outline.elementPlus,
                                onTap: () =>
                                    visibleAttach.value = !visibleAttach.value,
                              ),
                          ],
                        )
                      ],
                    )),
              );
            }),
      ],
    );
  }

  Widget homeBottomNavigationBar() {
    return ValueListenableBuilder(
        valueListenable: HomeCubit.indexed,
        builder: (context, indexed, _) {
          for (var element in navIcons) {
            element.setEnabled(false);
          }
          navIcons[indexed].setEnabled(true);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.10),
                      offset: const Offset(0, 20),
                      blurRadius: 46,
                      spreadRadius: 0,
                    ),
                  ]),
              child: Row(
                children: List.generate(navIcons.length, (index) {
                  final navIcon = navIcons[index];

                  return Expanded(
                    child: InkWell(
                        onTap: () {
                          if (index == indexed) return;

                          setState(() {
                            HomeCubit.indexed.value = index;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            navIcon.getIcon().svg(),
                            if (navIcon.enabled)
                              Text(
                                navIcon.title,
                                style: AppTextStyles.body6.copyWith(
                                    color: AppColors.primaryColor[800]),
                              )
                          ],
                        )),
                  );
                }),
              ),
            ),
          );
        });
  }
}
