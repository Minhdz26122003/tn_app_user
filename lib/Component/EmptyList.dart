import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    required this.title,
    required this.imgSrc,
    required this.content,
  });

  final String title, imgSrc, content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imgSrc,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorHex.textContent),
        ),
      ],
    );
  }
}
