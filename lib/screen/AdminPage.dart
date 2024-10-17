import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/room_controller.dart';
import 'package:flutter_aten/models/room_model.dart';
import 'package:flutter_aten/page/editroom.dart';
import 'package:flutter_aten/providers/user_provider.dart';
import 'package:flutter_aten/widget/customCliper.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<RoomModel> room = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchrooms();
  }

  Future<void> _fetchrooms() async {
    try {
      final roomList = await RoomController().getrooms(context);
      setState(() {
        room = roomList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching rooms: $error';
        isLoading = false;
      });
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
            // Background with gradient and custom clip path
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
                    decoration: const BoxDecoration(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'จัดการ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'ห้องและเครื่องมือ',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/insertroom');
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xff821131)),
                    //   child: const Text('เพิ่มข้อมูลใหม่',
                    //       style: TextStyle(color: Colors.white)),
                    // ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildtoolsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildtoolsList() {
    return Column(
      children: List.generate(room.length, (index) {
        final toolItem = room[index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: ListTile(
            title: Text('ชื่อห้อง: ${toolItem.roomName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('เวลาเข้า: ${toolItem.timeIn}'),
                Text('เวลาออก: ${toolItem.timeOut}'),
                Text('ชื่อเครื่องมือ: ${toolItem.toolName}'),
                Text('ผู้ใช้: ${toolItem.userName}'),
              ],
            ),
            // trailing: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.edit),
            //       onPressed: () => {}, // Add edit functionality
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.delete),
            //       onPressed: () => {}, // Add delete functionality
            //     ),
            //   ],
            // ),
          ),
        );
      }),
    );
  }
}
