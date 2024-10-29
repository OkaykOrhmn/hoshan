import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/ui/screens/home/chat/bloc/related_questions_bloc.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_bloc.dart';
import 'package:hoshan/ui/widgets/components/chat/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      controller: SendMessageBloc.scrollController,
      child: Column(
        children: [
          const SizedBox(
            height: 46,
          ),
          BlocConsumer<HomeCubit, List<Messages>>(
            builder: (context, state) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: state[index],
                    );
                  });
            },
            listener: (context, state) {},
          ),
          BlocBuilder<RelatedQuestionsBloc, RelatedQuestionsState>(
            builder: (context, state) {
              if (state is RelatedQuestionsSuccess &&
                  state.relatedQuestionsModel.questions != null &&
                  state.relatedQuestionsModel.questions!.isNotEmpty) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Assets.icon.outline.messageQuestion.svg(),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'سوالات مرتبط:',
                                  style: AppTextStyles.body4.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          AppColors.primaryColor.defaultShade),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              state.relatedQuestionsModel.questions!.length,
                          itemBuilder: (context, index) {
                            final question =
                                state.relatedQuestionsModel.questions![index];
                            return InkWell(
                              onTap: () {
                                context.read<HomeCubit>().addItem(
                                    Messages(content: question, role: 'human'));
                                context.read<HomeCubit>().addItem(
                                    Messages(role: 'ai', content: question));

                                context
                                    .read<RelatedQuestionsBloc>()
                                    .add(ClearAllRelatedQuestions());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      question,
                                      style: AppTextStyles.body5
                                          .copyWith(color: AppColors.gray[900]),
                                    ),
                                  ),
                                  if (index !=
                                      state.relatedQuestionsModel.questions!
                                              .length -
                                          1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Divider(
                                        color: AppColors.gray.defaultShade,
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          ValueListenableBuilder(
              valueListenable: HomeCubit.selectedFile,
              builder: (context, val, _) {
                return SizedBox(
                  height: val == null ? 90 : 190,
                );
              }),
        ],
      ),
    );
  }
}
