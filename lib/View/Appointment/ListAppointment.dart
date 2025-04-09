import 'package:app_hm/Component/EmptyList.dart';
import 'package:flutter/material.dart';

class ListAppointment extends StatelessWidget {
  const ListAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        title: const Text('Đặt dịch vụ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_car),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          const Center(
            child: EmptyList(
              imgSrc: 'assets/images/appointment_empty.png',
              title: 'Không có lịch hẹn sắp tới',
              content:
                  'Sau khi đặt lịch, bạn có thể theo dõi lịch hẹn dịch vụ tại đây.',
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 24, top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      // xử lý nhấn đặt dịch vụ
                    },
                    child: const Text(
                      'Đặt dịch vụ',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // xử lý nhấn vào Lịch sử dịch vụ
                    },
                    child: const Text(
                      'Lịch sử dịch vụ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
