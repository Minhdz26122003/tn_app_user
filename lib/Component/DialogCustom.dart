import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DialogCustom extends StatelessWidget {
  DialogCustom(
      {super.key,
      required this.title,
      required this.description,
      required this.svg,
      this.svgColor,
      this.btnColor,
      required this.onTap});

  String title;
  String description;
  String svg;
  Color? svgColor;
  Color? btnColor;
  GestureTapCallback onTap;

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
            const SizedBox(
              height: 12,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 244, 249, 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
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
                      'confirm'.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
