import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/room_controller.dart';
import 'package:flutter_aten/widget/customCliper.dart';

class insertroom extends StatefulWidget {
  @override
  _insertroomState createState() => _insertroomState();
}

class _insertroomState extends State<insertroom> {
  final _formKey = GlobalKey<FormState>();
  final RoomController _roomController =
      RoomController(); // Create ProductController instance
  DateTime dateTime = DateTime.now();
  String timein = '';
  String timeout = '';
  String roomName = '';
  String toolName = '';
  String userName = '';
  String phone = '';
  String objective = '';
  String adviser = '';

  // แยกฟังก์ชันสำหรับเพิ่มสินค้า
  void _addNewtool() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // บันทึกข้อมูลสินค้าใหม่โดยเรียกฟังก์ชัน insertProduct
      _roomController.Insertroom(
        context,
        DateTime.now(),
        timein,
        timeout,
        roomName,
        toolName,
        userName,
        phone,
        objective,
        adviser,
      ).then((response) {
        // ตรวจสอบว่าการเพิ่มสินค้าสำเร็จหรือไม่
        print(response.statusCode);

        if (response.statusCode == 201) {
          // Success action here (e.g. navigate back or show success message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else if (response.statusCode == 401) {
          // แสดงข้อความเมื่อเกิดข้อผิดพลาดในการเพิ่มสินค้า

          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      }).catchError((error) {
        // แสดงข้อความเมื่อเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
        );
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
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้าใหม่',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // _buildTextField(
                          //   label: 'วันที่',
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'กรุณากรอกข้อมูล';
                          //     }
                          //     return null;
                          //   },
                          //   onSaved: (value) {
                          //     dateTime = value! as DateTime;
                          //   },
                          // ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'เวลาเข้า',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              timein = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'เวลาออก',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              timeout = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'ห้อง',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              roomName = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'อุปกรณ์',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              toolName = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'ชื่อ',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userName = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'phone',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'วัตถุประสงค์',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              objective = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          _buildTextField(
                            label: 'ที่ปรึกษา',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกข้อมูล';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              adviser = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _addNewtool,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff821131),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'บันทึก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/home'); // เปลี่ยนไปยังหน้าแสดงสินค้า
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(103, 103, 103, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
