import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  final User user;
  final String accessToken;
  final String refreshToken;
  final String role;

  Usermodel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "role": role,
      };
}

class User {
  final String id;
  final String userName;
  final String password;
  final String name;
  final String role;

  User({
    required this.id,
    required this.userName,
    required this.password,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userName: json["user_name"],
        password: json["password"],
        name: json["name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "password": password,
        "name": name,
        "role": role,
      };
}
