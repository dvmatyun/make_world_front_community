import 'package:make_world_front_community/package_features/chat/domain/entities/chat_message.dart';
import 'package:make_world_front_community/package_features/chat/domain/entities/chat_room.dart';

abstract class IChatService {
  Stream<List<IChatRoom>> get chatRoomStream;
  Stream<List<IChatMessage>> get chatMessagesStream;
  Stream<IChatMessage> get newMessageStream;
  Stream<IChatRoom> get newChatStream;

  List<IChatMessage>? get chatMessagesSelected;
  List<IChatRoom>? get chatRooms;

  Stream<IChatRoom> get selectedChatRoomStream;
  IChatRoom? get chatRoomSelected;
  void selectChatRoom(String id);
  IChatRoom? getChatRoomById(String id);
  void postMessage(String message);

  void close();
}
