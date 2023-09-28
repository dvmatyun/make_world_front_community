// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/service/chat_service.dart';

@immutable
class ChatBody extends StatefulWidget {
  const ChatBody({required this.chatService, Key? key}) : super(key: key);
  final IChatService chatService;
  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  IChatService get chatService => widget.chatService;

  final _controller = ScrollController();
  String? selectedChatRoomId;
  StreamSubscription? streamSubscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    // ...
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<IChatMessage>>(
        initialData: chatService.chatMessagesSelected,
        stream: chatService.chatMessagesStream,
        builder: (c2, state) {
          if (!state.hasData || state.data == null) {
            return const Center(
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              ),
            );
          }
          final actChatRoomMsgs = state.data!;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
            child: ListView.builder(
              controller: _controller,
              itemCount: actChatRoomMsgs.length,
              itemBuilder: (context, index) {
                final msg = actChatRoomMsgs[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text:
                            '${msg.userName} (UTC ${msg.utcTime?.hour}:${msg.utcTime?.minute}:${msg.utcTime?.second}):',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(text: msg.message),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      );
}
