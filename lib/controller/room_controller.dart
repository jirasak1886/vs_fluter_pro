import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/auth_service.dart';
import 'package:flutter_aten/controller/varbles.dart';
import 'package:flutter_aten/models/room_model.dart';

import 'package:flutter_aten/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RoomController {
  final _AuthService = AuthService();

  Future<List<RoomModel>> getrooms(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/rooms'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${accessToken}", // ใส่ accessToken ใน header
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Decode the response and map it to ProductModel objects
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse.map((room) => RoomModel.fromJson(room)).toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception(
            'Refresh token expired. Please login again.'); // เพิ่ม throw Exception
      } else if (response.statusCode == 403) {
        // Refresh token and retry
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getrooms(context);
      } else {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }
    } catch (err) {
      // If the request failed, throw an error
      print(err);
      throw Exception('Failed to load products');
    }
  }

  Future<http.Response> Insertroom(
      BuildContext context,
      DateTime dateTime,
      String timeIn,
      String timeOut,
      String roomName,
      String toolName,
      String userName,
      String phone,
      String objective,
      String adviser) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> InsertData = {
      "date_time": DateTime.now().toIso8601String(),
      "time_in": timeIn,
      "time_out": timeOut,
      "room_name": roomName,
      "tool_name": toolName,
      "user_name": userName,
      "phone": phone,
      "objective": objective,
      "adviser": adviser,
    };
    try {
      print("--------");
      print(accessToken);
      print(InsertData);
      // Make POST request to insert the product

      final response = await http.post(
        Uri.parse("$apiURL/api/rooms"), // Replace with the correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(InsertData),
      );

      print(response.statusCode);

      // Handle successful product insertion
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
        return response; // ส่งคืน response เมื่อเพิ่มสินค้าสำเร็จ
      } else if (response.statusCode == 403) {
        await _AuthService.refreshToken(context);
        // accessToken = userProvider.accessToken;

        return await Insertroom(context, dateTime, timeIn, timeOut, roomName,
            toolName, userName, phone, objective, adviser);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      // Catch and print any errors during the request
      print(error);
      throw Exception('Failed to insert product: $error');
    }
  }

  Future<http.Response> updateroom(
      BuildContext context,
      //  DateTime Datetime,
      String timein,
      String timeout,
      String roomName,
      String toolName,
      String userName,
      String phone,
      String objective,
      String adviser,
      String roomID) async {
    // ใช้ roomID ตรงนี้
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      //   "date_time": Datetime,
      "time_in": timein,
      "time_out": timeout,
      "room_name": roomName,
      "tool_name": toolName,
      "user_name": userName,
      "phone": phone,
      "objective": objective,
      "adviser": adviser,
    };

    try {
      // Make PUT request to update the room
      final response = await http.put(
        Uri.parse("$apiURL/api/room/$roomID"), // แก้ไขเป็น roomID
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(updateData),
      );
      // Handle successful room update
      if (response.statusCode == 200) {
        print("Room updated successfully!");
        return response;
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await updateroom(context, timein, timeout, roomName, toolName,
            userName, phone, objective, adviser, roomID);
      } else {
        return response;
      }
    } catch (error) {
      throw Exception('Failed to update room');
    }
  }

  Future<http.Response> deleteroom(BuildContext context, String roomId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/room/$roomId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("Product deleted successfully!");
        return response; // ส่งคืน response
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await deleteroom(context, roomId);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}
