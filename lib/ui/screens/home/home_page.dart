// ignore_for_file: deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/file_manager/pick_file_services.dart';
import 'package:hoshan/data/model/home_navbar_model.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
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
                  HomeCubit.bot = null;
                  context.read<HomeCubit>().clearItems();

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
              appBar: const HomeAppbar(),
              body: IndexedStack(
                index: indexed,
                children: [
                  ValueListenableBuilder(
                      valueListenable: HomeCubit.chatId,
                      builder: (context, val, _) {
                        return val != null
                            ? val == -1
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

  Directionality homeMessageBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleIconBtn(
                icon: Assets.icon.bold.send,
                onTap: () async {
                  if (SendMessageBloc.onResponse.value) return;
                  if (message.text.isNotEmpty && HomeCubit.bot != null) {
                    HomeCubit.chatId.value ??= -2;
                    context.read<HomeCubit>().addItem(
                        Messages(content: message.text, role: 'human'));
                    context
                        .read<HomeCubit>()
                        .addItem(Messages(role: 'ai', content: message.text));

                    message.clear();
                  }
                },
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                  child: TextField(
                controller: message,
                onChanged: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'چیزی بنویسید ...',
                  hintStyle: AppTextStyles.body4,
                  fillColor: AppColors.gray[400],
                  contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              )),
              const SizedBox(
                width: 4,
              ),
              ValueListenableBuilder(
                  valueListenable: visibleAttach,
                  builder: (context, isVisible, _) {
                    return AnimatedVisibility(
                        isVisible: isVisible,
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            CircleIconBtn(
                              icon: Assets.icon.outline.galleryAdd,
                              onTap: () async =>
                                  await BottomSheetHandler(context)
                                      .showPickImage(),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CircleIconBtn(
                              icon: Assets.icon.outline.musicnote,
                              onTap: () async {
                                await PickFileService.getFile(
                                    fileType: FileType.audio);
                              },
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CircleIconBtn(
                                icon: Assets.icon.outline.cardAdd,
                                onTap: () async {
                                  await PickFileService.getFile(
                                      fileType: FileType.any);
                                }),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ));
                  }),
              CircleIconBtn(
                icon: Assets.icon.outline.elementPlus,
                onTap: () => visibleAttach.value = !visibleAttach.value,
              ),
            ],
          )),
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
