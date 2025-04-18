import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DialogCustom extends StatelessWidget {
  const DialogCustom({
    super.key,
    required this.title,
    required this.description,
    required this.svg,
    this.svgColor,
    this.btnColor,
    required this.onTap,
    this.showCancel = true, // Thêm tham số để ẩn/hiện nút cancel
  });

  final String title;
  final String description;
  final String svg;
  final Color? svgColor;
  final Color? btnColor;
  final GestureTapCallback onTap;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svg,
              colorFilter: svgColor == null
                  ? null
                  : ColorFilter.mode(
                      svgColor!,
                      BlendMode.srcIn,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showCancel) // Chỉ hiển thị nút cancel nếu showCancel là true
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 9),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 244, 249, 1),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                if (showCancel) const SizedBox(width: 12),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color:
                            btnColor ?? const Color.fromRGBO(55, 114, 255, 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'confirm'.tr, // Có thể đổi thành 'OK' nếu muốn
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
