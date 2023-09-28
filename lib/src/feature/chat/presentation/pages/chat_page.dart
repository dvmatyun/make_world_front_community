import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/chat/data/repository/chat_repository.dart';
import 'package:make_world_front_community/src/feature/chat/data/service/chat_service_impl.dart';
import 'package:make_world_front_community/src/feature/chat/domain/service/chat_service.dart';
import 'package:make_world_front_community/src/feature/chat/presentation/screens/chat_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final repo = ChatRepository();
  late final IChatService service = ChatServiceImpl(chatRepository: repo);

  @override
  Widget build(BuildContext context) {
    const name = 'Chat Page';
    return ScaffoldAim(
      key: const ValueKey(name),
      appBarWidget: const Text(name),
      metaName: name,
      body: ChatScreen(chatService: service),
    );
  }
}
