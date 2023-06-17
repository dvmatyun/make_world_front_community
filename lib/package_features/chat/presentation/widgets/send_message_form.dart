// Flutter imports:
import 'package:flutter/material.dart';
import 'package:make_world_front_community/package_features/chat/domain/service/chat_service.dart';

@immutable
class SendMessageForm extends StatelessWidget {
  SendMessageForm({required this.chatService, Key? key}) : super(key: key);

  final IChatService chatService;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                maxLines: null, //wrap text
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            width: 80,
            height: 40,
            child: TextButton(
              onPressed: () {
                chatService.postMessage(controller.text);
                controller.clear();
              },
              child: const Icon(
                Icons.send_rounded,
                size: 20,
                color: Colors.green,
              ),
            ),
          ),
        ],
      );
}
