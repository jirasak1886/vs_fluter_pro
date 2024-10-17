import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_aten/controller/varbles.dart';
import 'package:flutter_aten/models/User_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AuthService {
  Future<Usermodel?> login(String username, String password) async {
    print(username);
    print(password);
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'user_name': username,
        'password': password,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usermodel.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Register method
  Future<void> register(
      String username, String password, String name, String role) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    print('Response body: ${response.body}'); // Print the response body

    if (response.statusCode == 201) {
      // If registration is successful, handle success (e.g., navigate to login page)
      print('User registered successfully');
      return; // No need to return UserModel if the response isn't JSON
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.refreshToken}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      final accessToken = data['accessToken'];
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else if (response.statusCode == 401) {
      final accessToken = "";
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
