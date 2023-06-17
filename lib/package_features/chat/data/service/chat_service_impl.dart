// Dart imports:
import 'dart:async';

import 'package:make_world_front_community/package_features/chat/domain/entities/chat_message.dart';
import 'package:make_world_front_community/package_features/chat/domain/entities/chat_room.dart';
import 'package:make_world_front_community/package_features/chat/domain/repository/chat_repository.dart';
import 'package:make_world_front_community/package_features/chat/domain/service/chat_service.dart';

class ChatServiceImpl implements IChatService {
  final IChatRepository _chatRepository;
  final _chatRooms = <String, IChatRoom>{};

  final _chatMessagesSc = StreamController<List<IChatMessage>>.broadcast();
  @override
  Stream<List<IChatMessage>> get chatMessagesStream => _chatMessagesSc.stream;

  final _chatRoomsSc = StreamController<List<IChatRoom>>.broadcast();
  @override
  Stream<List<IChatRoom>> get chatRoomStream => _chatRoomsSc.stream;
  @override
  List<IChatRoom>? get chatRooms => _chatRooms.isEmpty ? null : _chatRooms.values.toList(growable: false);

  final _selectedChatRoomSc = StreamController<IChatRoom>.broadcast();
  @override
  Stream<IChatRoom> get selectedChatRoomStream => _selectedChatRoomSc.stream;

  IChatRoom? _selectedChatRoom;
  @override
  IChatRoom? get chatRoomSelected => _selectedChatRoom;

  StreamSubscription? _listenerChatMessage;
  StreamSubscription? _listenerChatRoom;

  ChatServiceImpl({required IChatRepository chatRepository}) : _chatRepository = chatRepository {
    _listenerChatMessage = _chatRepository.chatMessageStream.listen(_listenChatMessage);
    _listenerChatRoom = _chatRepository.chatRoomStream.listen(_listenChatRoom);
    _getChatRooms();
  }

  Future<void> _getChatRooms() async {
    final chatRooms = await _chatRepository.getChatRooms();
    final chatRoom = chatRooms?.firstOrNull;
    if (chatRoom == null) {
      return;
    }
    _listenChatRoom(chatRoom);
    selectChatRoom(chatRoom.id);
  }

  @override
  List<IChatMessage>? get chatMessagesSelected => _selectedChatRoom?.chatMessages;

  @override
  void postMessage(String message) {
    if (_selectedChatRoom == null) {
      return;
    }
    _chatRepository.postChatMessage(_selectedChatRoom!.id, message);
  }

  @override
  void selectChatRoom(String id) {
    _selectedChatRoom = _chatRooms[id];
    if (_selectedChatRoom == null) {
      return;
    }
    _selectedChatRoomSc.add(_selectedChatRoom!);
    _chatMessagesSc.add(_selectedChatRoom!.chatMessages);
  }

  void _listenChatMessage(IChatMessage chatMessage) {
    final chatRoom = _chatRooms[chatMessage.chatRoomId];
    if (chatRoom == null) {
      return;
    }
    chatRoom.chatMessages.add(chatMessage);
    chatRoom.chatMessages.sort((a, b) => a.utcTime!.compareTo(b.utcTime!) > 0 ? -1 : 1);
    if (chatRoom.id == _selectedChatRoom?.id) {
      _chatMessagesSc.add(chatRoom.chatMessages);
    }
    if (chatRoom.chatMessages.length > 100) {
      for (var i = 0; i < (chatRoom.chatMessages.length - 100); i++) {
        chatRoom.chatMessages.removeAt(i);
      }
    }
  }

  void _listenChatRoom(IChatRoom chatRoomModel) {
    _chatRooms[chatRoomModel.id] = chatRoomModel;
  }

  @override
  void close() {
    _listenerChatMessage?.cancel();
    _listenerChatRoom?.cancel();
    _selectedChatRoomSc.close();
    _chatMessagesSc.close();
    _chatRoomsSc.close();
  }

  @override
  Stream<IChatRoom> get newChatStream => _chatRepository.chatRoomStream;

  @override
  Stream<IChatMessage> get newMessageStream => _chatRepository.chatMessageStream;

  @override
  IChatRoom? getChatRoomById(String id) => _chatRooms[id];
}
