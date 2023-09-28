// Flutter imports:
import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/chat/domain/service/chat_service.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

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
          const Text('Go home here'),
          TextButton(
            onPressed: () {
              Router.navigate(context, () {
                MyRouterDelegate.of(context).setNewRoutePath(AppConfigAim.custom(HomePage.routeName));
                //(Router.of(context).routerDelegate as MyRouterDelegate).handleBookTapped(book);
              });
            },
            child: const Text('Go to home'),
          ),
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
