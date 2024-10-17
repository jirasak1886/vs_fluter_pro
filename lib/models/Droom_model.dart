// To parse this JSON data, do
//
//     final droomModeel = droomModeelFromJson(jsonString);

import 'dart:convert';

DroomModeel droomModeelFromJson(String str) => DroomModeel.fromJson(json.decode(str));

String droomModeelToJson(DroomModeel data) => json.encode(data.toJson());

class DroomModeel {
    final String id;
    final String roomNumber;
    final String roomName;

    DroomModeel({
        required this.id,
        required this.roomNumber,
        required this.roomName,
    });

    factory DroomModeel.fromJson(Map<String, dynamic> json) => DroomModeel(
        id: json["_id"],
        roomNumber: json["room_number"],
        roomName: json["room_name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "room_number": roomNumber,
        "room_name": roomName,
    };
}