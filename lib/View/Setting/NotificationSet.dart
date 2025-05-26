import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:permission_handler/permission_handler.dart';

class Notificationset extends StatefulWidget {
  const Notificationset({Key? key}) : super(key: key);

  @override
  State<Notificationset> createState() => _NotificationsetState();
}

class _NotificationsetState extends State<Notificationset> {
  bool _allowNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    final status = await Permission.notification.status;
    setState(() {
      _allowNotifications = status.isGranted;
    });
  }

  Future<void> _onToggleNotifications(bool value) async {
    if (value) {
      final result = await Permission.notification.request();
      setState(() {
        _allowNotifications = result.isGranted;
      });
    } else {
      // Hướng dẫn user vào cài đặt tắt notification
      openAppSettings();
    }
  }

  Future<void> _openAppSettings() => openAppSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt thông báo',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Thông báo'),
            tiles: [
              // SettingsTile.switchTile(
              //   initialValue: _allowNotifications,
              //   onToggle: _onToggleNotifications,
              //   leading: const Icon(Icons.notifications),
              //   title: const Text('Bật thông báo'),
              // ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: const Text('Quyền thông báo',
                    style: TextStyle(fontSize: 14)),
                onPressed: (context) => _openAppSettings(),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Hệ thống', style: TextStyle(fontSize: 13)),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.battery_charging_full),
                title: const Text('Tắt tối ưu hóa pin',
                    style: TextStyle(fontSize: 14)),
                onPressed: (context) {
                  // TODO: Hiển thị modal hướng dẫn tắt tối ưu pin
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text('Hướng dẫn tắt tối ưu pin',
                                style: TextStyle(fontSize: 14)),
                            content: const Text(
                                'Vào Settings > Battery & Performance > App battery saver '
                                'chọn ứng dụng này và thiết lập "No restrictions".',
                                style: TextStyle(fontSize: 13)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Đã hiểu',
                                      style: TextStyle(fontSize: 14)))
                            ],
                          ));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.sync),
                title: const Text('Cho phép chạy nền',
                    style: TextStyle(fontSize: 14)),
                onPressed: (context) {
                  // TODO: Hiển thị modal hướng dẫn bật chạy nền (MIUI, OneUI…)
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text('Hướng dẫn bật chạy nền',
                                style: TextStyle(fontSize: 14)),
                            content: const Text(
                                'Vào Settings > Apps > YourApp > Battery > '
                                'Cho phép hoạt động dưới nền và Autostart.',
                                style: TextStyle(fontSize: 14)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Đã hiểu',
                                      style: TextStyle(fontSize: 14)))
                            ],
                          ));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.settings),
                title: const Text('Cài đặt ứng dụng',
                    style: TextStyle(fontSize: 14)),
                onPressed: (context) => _openAppSettings(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
