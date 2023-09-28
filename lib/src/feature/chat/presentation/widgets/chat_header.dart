// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

import '../../domain/service/chat_service.dart';

@immutable
class ChatHeader extends StatefulWidget {
  const ChatHeader({required this.chatService, Key? key}) : super(key: key);
  final IChatService chatService;
  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  IChatService get chatService => widget.chatService;

  StreamSubscription? _chatRoomsSub;

  @override
  void initState() {
    super.initState();
    _chatRoomsSub = chatService.chatRoomStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // ...
    _chatRoomsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 6),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('Select chat here'),
            ),
            Icon(Icons.close),
          ],
        ),
      );
}
