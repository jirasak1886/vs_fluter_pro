import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/room_controller.dart';
import 'package:flutter_aten/models/room_model.dart';
import 'package:flutter_aten/page/editroom.dart';
import 'package:flutter_aten/providers/user_provider.dart';
import 'package:flutter_aten/widget/customCliper.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<RoomModel> rooms = []; // แก้ไขชื่อเป็น toolModel
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchrooms();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).onLogout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchrooms() async {
    try {
      final toolList = await RoomController().getrooms(context);
      setState(() {
        rooms = toolList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching tools: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching tools: $error')));
    }
  }

  // ฟังก์ชันสำหรับการแก้ไขห้อง
  void updateroom(RoomModel room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditroomPage(room: room),
      ),
    );
  }

  Future<void> deleteroom(RoomModel room) async {
    // แสดงกล่องยืนยันก่อนทำการลบ
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // ปิดกล่องและส่งค่ากลับ false
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true); // ปิดกล่องและส่งค่ากลับ true
              },
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      try {
        final response = await RoomController().deleteroom(context, room.id);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
          await _fetchrooms();
        } else if (response.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Refresh token expired. Please login again.')));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE9EFEC),
                          Color(0xffFABC3F),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'จัดการ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20),
                    // Consumer<UserProvider>(
                    //   builder: (context, userProvider, _) {
                    //     return Column(
                    //       children: [
                    //         Text('Access Token : ',
                    //             style: TextStyle(
                    //                 fontSize: 18,
                    //                 color: Colors.black,
                    //                 fontWeight: FontWeight.bold)),
                    //         Text('${userProvider.accessToken}',
                    //             style: TextStyle(
                    //                 fontSize: 16, color: Color(0xff821131))),
                    //         SizedBox(height: 15),
                    //         Text('Refresh Token : ',
                    //             style: TextStyle(
                    //                 fontSize: 18,
                    //                 color: Colors.black,
                    //                 fontWeight: FontWeight.bold)),
                    //         Text('${userProvider.refreshToken}',
                    //             style: TextStyle(
                    //                 fontSize: 16, color: Color(0xffFABC3F))),
                    //         SizedBox(height: 20),
                    //         ElevatedButton(
                    //           onPressed: () {
                    //             AuthService().refreshToken(context);
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //               backgroundColor: const Color(0xff821131)),
                    //           child: Text('Update Token',
                    //               style: TextStyle(color: Colors.white)),
                    //         )
                    //       ],
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/insertroom');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff821131)),
                      child: Text('เพิ่มสินค้าใหม่',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildtoolList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(Icons.logout, color: Color(0xff821131), size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildtoolList() {
    return Column(
      children: List.generate(rooms.length, (index) {
        final toolItem = rooms[index];
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: ListTile(
            title: Text(toolItem.id),
            subtitle: Text('ID: ${toolItem.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => updateroom(toolItem),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteroom(toolItem),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
