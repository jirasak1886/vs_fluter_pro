import 'dart:convert';
DtoolModeel dtoolModeelFromJson(String str) =>
    DtoolModeel.fromJson(json.decode(str));

String dtoolModeelToJson(DtoolModeel data) => json.encode(data.toJson());

class DtoolModeel {
  final String id;
  final String toolNumber;
  final String toolName;

  DtoolModeel({
    required this.id,
    required this.toolNumber,
    required this.toolName,
  });

  factory DtoolModeel.fromJson(Map<String, dynamic> json) => DtoolModeel(
        id: json["_id"],
        toolNumber: json["tool_number"],
        toolName: json["tool_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tool_number": toolNumber,
        "tool_name": toolName,
      };
}
