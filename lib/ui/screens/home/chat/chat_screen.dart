import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/widgets/components/chat/bloc/send_message_bloc.dart';

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
      controller: SendMessageBloc.scrollController,
      reverse: true,
      child: const Column(
        children: [
          SizedBox(
            height: 46,
          ),
          // BlocConsumer<HomeCubit, HomeCubitState>(
          //   builder: (context, state) {
          //     return ListView.builder(
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemCount: state.length,
          //         itemBuilder: (context, index) => ChatBubble(
          //               message: state[index],
          //             ));
          //   },
          //   listener: (context, state) {},
          // ),
          SizedBox(
            height: 58,
          ),
        ],
      ),
    );
  }
}
