import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionGuide extends StatelessWidget {
  const PermissionGuide({super.key});

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  Widget _buildStep(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      leading: Icon(icon, size: 36, color: Colors.blueAccent),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hướng dẫn cấp quyền',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Để app hoạt động đầy đủ, vui lòng cấp các quyền sau:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildStep(
              icon: Icons.notifications_active,
              title: 'Quyền Thông báo',
              subtitle: 'Bật thông báo để nhận nhắc lịch và cập nhật.',
            ),
            _buildStep(
              icon: Icons.settings_power,
              title: 'Hoạt động nền',
              subtitle: 'Cho phép app chạy ở nền để gửi nhắc chính xác.',
            ),
            _buildStep(
              icon: Icons.battery_charging_full,
              title: 'Không tối ưu pin',
              subtitle: 'Tắt tối ưu pin để app không bị chặn.',
            ),
            const Spacer(),
            // Center(
            //   child: ElevatedButton.icon(
            //     icon: const Icon(
            //       Icons.settings,
            //       color: ColorHex.white,
            //     ),
            //     label: const Text(
            //       'Mở Cài đặt App',
            //       style: TextStyle(color: ColorHex.white),
            //     ),
            //     onPressed: () => _openSettings(),
            //     style: ElevatedButton.styleFrom(
            //       side: const BorderSide(color: ColorHex.grey),
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //       textStyle: const TextStyle(fontSize: 16),
            //       backgroundColor: ColorHex.total_color,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
