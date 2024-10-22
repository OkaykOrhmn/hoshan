import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/screens/home/library/bloc/chats_history_bloc.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/text/search_text_field.dart';
import 'package:hoshan/ui/widgets/sections/empty/empty_states.dart';
import 'package:hoshan/ui/widgets/sections/loading/listview_placeholder.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsHistoryBloc, ChatsHistoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChatsHistorySuccess) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SearchTextField(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Assets.icon.outline.filter.svg(),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: state.chats.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  chat.title!,
                                  style: AppTextStyles.body4,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(chat.createdAt!)
                              ],
                            ),
                          ),
                          Assets.icon.outline.more.svg()
                        ],
                      ),
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ));
        } else {
          return Center(
            child: EmptyStates.messages(),
          );
        }
      },
    );
  }
}
