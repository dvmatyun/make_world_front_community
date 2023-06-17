// Flutter imports:
import 'package:flutter/material.dart';
import 'package:make_world_front_community/package_features/chat/domain/service/chat_service.dart';

import '../widgets/chat_body.dart';
import '../widgets/chat_header.dart';
import '../widgets/send_message_form.dart';

@immutable
class ChatScreen extends StatelessWidget {
  const ChatScreen({required this.chatService, this.chosenChatId, Key? key}) : super(key: key);

  final String? chosenChatId;
  final IChatService chatService;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ChatHeader(
              chatService: chatService,
            ),
          ),
          SizedBox(
            height: 60,
            child: SendMessageForm(
              chatService: chatService,
            ),
          ),
          Expanded(
            child: ChatBody(
              chatService: chatService,
            ),
          ),
        ],
      );
}
