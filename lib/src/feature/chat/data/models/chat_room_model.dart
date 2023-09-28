// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:make_world_front_community/src/feature/chat/domain/entities/chat_room.dart';

import 'chat_message.dart';

// Project imports:

part 'chat_room_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatRoomModel extends Equatable implements IChatRoom {
  @override
  final String id;

  @override
  final String chatName;

  @override
  final List<ChatMessage> chatMessages;
  @override
  final List<String>? chatUsers;
  @override
  final bool isRemoved;

  const ChatRoomModel({
    required this.chatMessages,
    this.id = '',
    this.chatName = '',
    this.chatUsers,
    this.isRemoved = false,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);

  static ChatRoomModel? fromJsonString(Object? source) {
    if (source == null) {
      return null;
    } else if (source is String) {
      final Object? data = jsonDecode(source);
      final model = data is Map<String, Object?> ? ChatRoomModel.fromJson(data) : null;
      return model;
    }
    throw FormatException('Unknown json source type: ${source.runtimeType}');
  }

  @override
  List<Object?> get props => [id, chatName, isRemoved, chatUsers, chatMessages];
}
