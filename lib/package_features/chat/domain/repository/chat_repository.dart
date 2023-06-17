import 'package:make_world_front_community/package_features/chat/domain/entities/chat_message.dart';
import 'package:make_world_front_community/package_features/chat/domain/entities/chat_room.dart';

abstract class IChatRepository {
  Stream<IChatRoom> get chatRoomStream;
  Stream<IChatMessage> get chatMessageStream;

  void postChatMessage(String chatRoomId, String message);
  Future<List<IChatRoom>?> getChatRooms();

  void close();
}
