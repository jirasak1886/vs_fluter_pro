import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/auth_service.dart';
import 'package:flutter_aten/controller/varbles.dart';
import 'package:flutter_aten/models/Droom_model.dart';

import 'package:flutter_aten/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DroomController {
  final _AuthService = AuthService();

  Future<List<DroomModeel>> getdrooms(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/dr/drooms/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${accessToken}", // ใส่ accessToken ใน header
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Decode the response and map it to ProductModel objects
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((room) => DroomModeel.fromJson(room)).toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception(
            'Refresh token expired. Please login again.'); // เพิ่ม throw Exception
      } else if (response.statusCode == 403) {
        // Refresh token and retry
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getdrooms(context);
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

  Future<http.Response> Insertdroom(
    BuildContext context,
    String roomNumber,
    String roomName,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> InsertData = {
      "room_number": roomNumber,
      "room_name": roomName,
    };
    try {
      // Make POST request to insert the product
      final response = await http.post(
        Uri.parse(
            "$apiURL/api/dr/drooms"), // Replace with the correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken" // Attach accessToken
        },
        body: jsonEncode(InsertData),
      );

      // Handle successful product insertion
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
        return response; // ส่งคืน response เมื่อเพิ่มสินค้าสำเร็จ
      } else if (response.statusCode == 403) {
        await _AuthService.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await Insertdroom(context, roomName, roomNumber);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      // Catch and print any errors during the request
      throw Exception('Failed to insert product');
    }
  }

  Future<http.Response> updatedroom(BuildContext context, String roomNumber,
      String roomName, String DroomID) async {
    // ใช้ roomID ตรงนี้
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "room_number": roomNumber,
      "room_name": roomName,
    };

    try {
      // Make PUT request to update the room
      final response = await http.put(
        Uri.parse("$apiURL/api/dr/droom/$DroomID"), // แก้ไขเป็น roomID
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

        return await updatedroom(context, roomNumber, roomName, DroomID);
      } else {
        return response;
      }
    } catch (error) {
      throw Exception('Failed to update room');
    }
  }

  Future<http.Response> deletedroom(
      BuildContext context, String DroomId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/dr/droom/$DroomId"),
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

        return await deletedroom(context, DroomId);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}
