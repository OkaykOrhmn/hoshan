import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
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
                  itemBuilder: (context, index) => ChatBubble(
                        message: state[index],
                      ));
            },
            listener: (context, state) {},
          ),
          const SizedBox(
            height: 58,
          ),
        ],
      ),
    );
  }
}
