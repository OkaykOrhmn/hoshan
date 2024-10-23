import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hoshan/ui/widgets/sections/loading/default_placeholder.dart';

class ChatScreenPlaceholder extends StatelessWidget {
  const ChatScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 46,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) => DefaultPlaceHolder(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(index % 2 == 0 ? 16 : 32, 0,
                          index % 2 == 0 ? 32 : 16, 16),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: Random().nextInt(57) + 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10).copyWith(
                              topRight:
                                  Radius.circular(index % 2 == 0 ? 10 : 0),
                              bottomLeft:
                                  Radius.circular(index % 2 == 0 ? 0 : 10)),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
