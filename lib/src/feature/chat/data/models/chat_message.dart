// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:make_world_front_community/src/feature/chat/domain/entities/chat_message.dart';

part 'chat_message.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatMessage implements IChatMessage {
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? chatRoomId;
  @override
  final String message;
  @override
  final DateTime? utcTime;
  @override
  final String? toUserId;

  ChatMessage({
    this.userId = '',
    this.userName = '-',
    this.chatRoomId,
    this.message = '',
    this.utcTime,
    this.toUserId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  static ChatMessage? fromJsonString(Object? source) {
    if (source == null) {
      return null;
    } else if (source is String) {
      final Object? data = jsonDecode(source);
      final model = data is Map<String, Object?> ? ChatMessage.fromJson(data) : null;
      return model;
    }
    throw FormatException('Unknown json source type: ${source.runtimeType}');
  }
}
