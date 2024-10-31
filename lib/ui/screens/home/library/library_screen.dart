// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/utils/date_time.dart';
import 'package:hoshan/data/model/ai/chats_history_model.dart';
import 'package:hoshan/data/model/popup_menu_model.dart';
import 'package:hoshan/ui/screens/home/chat/bloc/related_questions_bloc.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/screens/home/library/bloc/chats_history_bloc.dart';
import 'package:hoshan/ui/screens/home/library/cubit/handle_archive_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/screens/home/library/cubit/chat_row_edit_cubit.dart';
import 'package:hoshan/ui/widgets/components/dialog/dialog_handler.dart';
import 'package:hoshan/ui/widgets/components/text/auth_text_field.dart';
import 'package:hoshan/ui/widgets/components/text/search_text_field.dart';
import 'package:hoshan/ui/widgets/sections/empty/empty_states.dart';
import 'package:hoshan/ui/widgets/sections/header/primary_appbar.dart';
import 'package:hoshan/ui/widgets/sections/loading/default_placeholder.dart';
import 'package:hoshan/ui/widgets/sections/loading/listview_placeholder.dart';
import 'package:shamsi_date/shamsi_date.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void dispose() {
    super.dispose();
    EasyDebounce.cancelAll();
  }

  String? date;
  Jalali? dateJalali;
  final TextEditingController searchTextController = TextEditingController();
  bool archive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(
        titleText: archive ? 'آرشیو شده ها' : 'همه پیام ها',
        actions: [
          const SizedBox(
            width: 16,
          ),
          InkWell(
              onTap: () async {
                await DialogHandler(context: context).showDeleteItem(
                  title: 'همه نتایج جستجو پاک شوند؟',
                  description: '.با این کار اطلاعات شما از بین خواهد رفت',
                  onConfirm: () {
                    context
                        .read<ChatsHistoryBloc>()
                        .add(RemoveAll(archive: archive));
                  },
                );
              },
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Assets.icon.outline.trash
                      .svg(color: AppColors.black[300]))),
          const SizedBox(
            width: 24,
          ),
          InkWell(
              onTap: () async {
                archive = !archive;
                context.read<ChatsHistoryBloc>().add(GetAllChats(
                    search: searchTextController.text,
                    date: date,
                    archive: archive));
                setState(() {});
              },
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Assets.icon.outline.directInbox
                      .svg(color: AppColors.black[300]))),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SearchTextField(
              controller: searchTextController,
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: InkWell(
                  onTap: () async {
                    await DialogHandler(context: context).showDatePicker(
                      dateCounts: 1,
                      selectedDates: dateJalali != null ? [dateJalali!] : null,
                      onConfirm: (p0) {
                        if (p0.isEmpty) {
                          if (date != null) {
                            date = null;
                            dateJalali = null;
                            context.read<ChatsHistoryBloc>().add(GetAllChats(
                                search: searchTextController.text,
                                date: date,
                                archive: archive));
                          }

                          return;
                        }

                        dateJalali = p0.first;
                        DateTime miladiDate = dateJalali!.toDateTime();
                        date =
                            '${miladiDate.year}-${miladiDate.month}-${miladiDate.day}';
                        context.read<ChatsHistoryBloc>().add(GetAllChats(
                            search: searchTextController.text,
                            date: date,
                            archive: archive));
                      },
                    );
                  },
                  child: Assets.icon.outline.filter.svg(),
                ),
              ),
              onChanged: (searchText) {
                if (searchText.isEmpty) {
                  EasyDebounce.cancelAll();
                  context
                      .read<ChatsHistoryBloc>()
                      .add(GetAllChats(date: date, archive: archive));
                  return;
                }
                EasyDebounce.debounce(
                    'my-debouncer', // <-- An ID for this particular debouncer
                    const Duration(seconds: 1), // <-- The debounce duration
                    () {
                  context.read<ChatsHistoryBloc>().add(GetAllChats(
                      search: searchText, date: date, archive: archive));
                } // <-- The target method
                    );
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<ChatsHistoryBloc, ChatsHistoryState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ChatsHistorySuccess) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: state.chatsInDates.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, allIndex) {
                            return state.chatsInDates[allIndex].chats.isEmpty
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              state
                                                  .chatsInDates[allIndex].title,
                                              style: AppTextStyles.body3
                                                  .copyWith(
                                                      color:
                                                          AppColors.black[900],
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        itemCount: state.chatsInDates[allIndex]
                                            .chats.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, chatIndex) {
                                          final chat = state
                                              .chatsInDates[allIndex]
                                              .chats[chatIndex];
                                          return chatRow(context, chat);
                                        },
                                      ),
                                    ],
                                  );
                          },
                        )
                      ],
                    ),
                  );
                } else if (state is ChatsHistoryLoading) {
                  return ListviewPlaceholder(
                      child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 58,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                  ));
                } else {
                  return Center(
                    child: EmptyStates.messages(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chatRow(BuildContext context, Chats chatModel) {
    final List<PopupMenuModel> popups = [
      PopupMenuModel(
          id: 0, title: 'تغییر نام', icon: Assets.icon.outline.edit2),
      // PopupMenuModel(
      //     id: 1, title: 'به اشتراک گذاری', icon: Assets.icon.outline.share),
      PopupMenuModel(
          id: 2,
          title: archive ? 'خارج کردن' : 'آرشیو کردن',
          icon: Assets.icon.outline.directInbox),
      PopupMenuModel(id: 3, title: 'پاک کردن', icon: Assets.icon.outline.trash),
    ];
    late final TextEditingController editingController = TextEditingController(
      text: chatModel.title!.replaceAll("\"", ''),
    );
    ValueNotifier<bool> isEdit = ValueNotifier(false);

    late Chats chat = chatModel;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatRowEditCubit>(create: (context) => ChatRowEditCubit()),
        BlocProvider<HandleArchiveCubit>(
            create: (context) => HandleArchiveCubit()),
      ],
      child: BlocConsumer<HandleArchiveCubit, HandleArchiveState>(
        listener: (context, archState) {
          if (archState is HandleArchiveSuccess) {
            context
                .read<ChatsHistoryBloc>()
                .add(RemoveChat(chats: chat, withCall: false));
          }
        },
        builder: (context, archState) {
          if (archState is HandleArchiveLoading) {
            return DefaultPlaceHolder(
                child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 58,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ));
          }
          return BlocBuilder<ChatRowEditCubit, ChatRowEditState>(
            builder: (context, state) {
              return InkWell(
                onTap: () async {
                  HomeCubit.indexed.value = 0;
                  HomeCubit.chatId.value = -1;

                  await context.read<HomeCubit>().getItems(id: chat.id!);
                  final humanMessage =
                      await context.read<HomeCubit>().getLatsHumanMessage();
                  if (humanMessage != null) {
                    context.read<RelatedQuestionsBloc>().add(
                        GetAllRelatedQuestions(
                            chatId: HomeCubit.chatId.value!,
                            messageId: humanMessage.id!,
                            content: humanMessage.content!.single.text!));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: ValueListenableBuilder(
                      valueListenable: isEdit,
                      builder: (context, edit, _) {
                        return Row(
                          children: [
                            state is ChatRowEditLoading
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color:
                                          AppColors.primaryColor.defaultShade,
                                    ),
                                  )
                                : edit
                                    ? InkWell(
                                        onTap: () async {
                                          await context
                                              .read<ChatRowEditCubit>()
                                              .editTitle(
                                                  id: chat.id!,
                                                  title:
                                                      editingController.text);
                                          chat = chat.copyWith(
                                              title: editingController.text);
                                          isEdit.value = false;
                                        },
                                        child: Assets.icon.outline.tickCircle
                                            .svg())
                                    : PopupMenuButton<PopupMenuModel>(
                                        offset: const Offset(0, 18),
                                        onSelected: (value) async {
                                          switch (value.id) {
                                            case 0:
                                              isEdit.value = true;
                                              break;
                                            case 1:
                                              break;
                                            case 2:
                                              archive
                                                  ? await context
                                                      .read<
                                                          HandleArchiveCubit>()
                                                      .removeFromArchive(
                                                          chat.id!)
                                                  : await context
                                                      .read<
                                                          HandleArchiveCubit>()
                                                      .addToArchive(chat.id!);
                                              break;
                                            case 3:
                                              // widget.onDelete.call();
                                              await DialogHandler(
                                                      context: context)
                                                  .showDeleteItem(
                                                title: 'چت',
                                                onConfirm: () {
                                                  context
                                                      .read<ChatsHistoryBloc>()
                                                      .add(RemoveChat(
                                                          chats: chat));
                                                },
                                              );
                                              break;
                                            default:
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        itemBuilder: (BuildContext context) {
                                          return <PopupMenuEntry<
                                              PopupMenuModel>>[
                                            ...List.generate(
                                              popups.length,
                                              (index) =>
                                                  PopupMenuItem<PopupMenuModel>(
                                                value: popups[index],
                                                height: 32,
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Column(
                                                    children: [
                                                      if (index == 0)
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                      Row(
                                                        children: [
                                                          if (popups[index]
                                                                  .icon !=
                                                              null)
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child: popups[
                                                                          index]
                                                                      .icon!
                                                                      .svg(
                                                                          color: AppColors
                                                                              .secondryColor
                                                                              .defaultShade),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                )
                                                              ],
                                                            ),
                                                          Text(
                                                            popups[index].title,
                                                            style: AppTextStyles
                                                                .body6
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: index !=
                                                                popups.length -
                                                                    1
                                                            ? AppColors.gray
                                                                .defaultShade
                                                            : Colors
                                                                .transparent,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ];
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Assets.icon.outline.more
                                              .svg(color: AppColors.gray[900]),
                                        )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  edit
                                      ? AuthTextField(
                                          controller: editingController,
                                          maxLines: 4,
                                          minLines: 4,
                                        )
                                      : Text(
                                          chat.title!.replaceAll("\"", ''),
                                          style: AppTextStyles.body4,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    DateTimeUtils
                                        .convertStringIsoToStringInFormatted(
                                            chat.createdAt!),
                                    style: AppTextStyles.body5
                                        .copyWith(color: AppColors.gray[900]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
