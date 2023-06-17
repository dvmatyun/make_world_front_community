import 'dart:async';

import 'package:make_world_front_community/package_features/chat/data/models/chat_message.dart';
import 'package:make_world_front_community/package_features/chat/data/models/chat_room_model.dart';
import 'package:make_world_front_community/package_features/chat/domain/entities/chat_message.dart';
import 'package:make_world_front_community/package_features/chat/domain/entities/chat_room.dart';
import 'package:make_world_front_community/package_features/chat/domain/repository/chat_repository.dart';

class ChatRepository implements IChatRepository {
  @override
  Stream<IChatMessage> get chatMessageStream => _chatMessageSc.stream;

  @override
  Stream<IChatRoom> get chatRoomStream => const Stream.empty();

  final _chatMessageSc = StreamController<IChatMessage>.broadcast();

  @override
  void close() {
    _chatMessageSc.close();
  }

  @override
  Future<List<IChatRoom>?> getChatRooms() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final chatMessages = <ChatMessage>[
      ChatMessage(
        chatRoomId: '1',
        userName: 'TestUser',
        message: 'message 1',
        utcTime: DateTime.now().toUtc(),
      ),
      ChatMessage(
        chatRoomId: '1',
        userName: 'TestUser',
        message: 'message 2',
        utcTime: DateTime.now().toUtc(),
      ),
      ChatMessage(
        chatRoomId: '1',
        userName: 'TestUser',
        message: 'message 3',
        utcTime: DateTime.now().toUtc(),
      ),
      ChatMessage(
        chatRoomId: '1',
        userName: 'TestUser',
        message: 'message 4',
        utcTime: DateTime.now().toUtc(),
      ),
      ChatMessage(
        chatRoomId: '1',
        userName: 'TestUser',
        message: 'message 5',
        utcTime: DateTime.now().toUtc(),
      ),
    ];
    return [
      ChatRoomModel(
        chatMessages: chatMessages,
        id: '1',
        chatName: 'Global',
      ),
    ];
  }

  @override
  void postChatMessage(String chatRoomId, String message) {
    Future<void>.delayed(const Duration(milliseconds: 300)).then((value) {
      if (_chatMessageSc.isClosed) {
        return;
      }
      _chatMessageSc.add(
        ChatMessage(
          chatRoomId: '1',
          userName: 'TestUser',
          message: message,
          utcTime: DateTime.now().toUtc(),
        ),
      );
    });
  }
}
