abstract class IChatMessage {
  String get userId;
  String get userName;
  String? get chatRoomId;
  String get message;
  DateTime? get utcTime;
  String? get toUserId;
}
