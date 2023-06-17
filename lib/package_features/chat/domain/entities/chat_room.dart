import 'chat_message.dart';

abstract class IChatRoom {
  String get id;

  String get chatName;

  List<IChatMessage> get chatMessages;
  List<String>? get chatUsers;
  bool get isRemoved;
}
