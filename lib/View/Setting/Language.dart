import 'package:app_hm/Services/TranslationService.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('language'.tr),
        backgroundColor: const Color(0xFF2D74FF),
        titleSpacing: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            _item(
                languageCode: 'vi_VN',
                title: 'Tiếng Việt',
                svg: 'assets/icons/vietnam.svg'),
            _item(
                title: 'English',
                svg: 'assets/icons/united_states.svg',
                languageCode: 'en_US'),
          ],
        ),
      ),
    );
  }

  _item(
      {required String title,
      required String svg,
      required String languageCode}) {
    return GestureDetector(
      onTap: () {
        if (languageCode == 'vi_VN') {
          TranslationService.changeLocale('vi');
          Utils.showSnackBar(
              duration: Duration(seconds: 1),
              title: 'Thông báo',
              message: 'Đã chuyển ngôn ngữ sang Tiếng VIệt.');
          Get.back();
        } else {
          TranslationService.changeLocale('en');
          Utils.showSnackBar(
              duration: Duration(seconds: 1),
              title: 'Thông báo',
              message: 'Language has been changed to English.');
          Get.back();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svg,
            ),
            const SizedBox(width: 15),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            )),
            const SizedBox(width: 10),
            Get.locale.toString() == languageCode
                ? const Icon(
                    Icons.done_rounded,
                    size: 22,
                    color: Colors.green,
                  )
                : const SizedBox(
                    height: 22,
                  ),
          ],
        ),
      ),
    );
  }
}
