import 'package:meta/meta.dart';
import 'dart:convert';

class RoomModel {
  final String id;
  final DateTime dateTime;
  final String timeIn;
  final String timeOut;
  final String roomName;
  final String toolName;
  final String userName;
  final String phone;
  final String objective;
  final String adviser;

  RoomModel({
    required this.id,
    required this.dateTime,
    required this.timeIn,
    required this.timeOut,
    required this.roomName,
    required this.toolName,
    required this.userName,
    required this.phone,
    required this.objective,
    required this.adviser,
  });

  RoomModel copyWith({
    String? id,
    DateTime? dateTime,
    String? timeIn,
    String? timeOut,
    String? roomName,
    String? toolName,
    String? userName,
    String? phone,
    String? objective,
    String? adviser,
  }) =>
      RoomModel(
        id: id ?? this.id,
        dateTime: dateTime ?? this.dateTime,
        timeIn: timeIn ?? this.timeIn,
        timeOut: timeOut ?? this.timeOut,
        roomName: roomName ?? this.roomName,
        toolName: toolName ?? this.toolName,
        userName: userName ?? this.userName,
        phone: phone ?? this.phone,
        objective: objective ?? this.objective,
        adviser: adviser ?? this.adviser,
      );

  factory RoomModel.fromRawJson(String str) =>
      RoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["_id"],
        dateTime: DateTime.parse(json["date_time"]),
        timeIn: json["time_in"],
        timeOut: json["time_out"],
        roomName: json["room_name"],
        toolName: json["tool_name"],
        userName: json["user_name"],
        phone: json["phone"],
        objective: json["objective"],
        adviser: json["adviser"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date_time": dateTime.toIso8601String(),
        "time_in": timeIn,
        "time_out": timeOut,
        "room_name": roomName,
        "tool_name": toolName,
        "user_name": userName,
        "phone": phone,
        "objective": objective,
        "adviser": adviser,
      };
}
