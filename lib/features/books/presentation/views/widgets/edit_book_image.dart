import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class EditBookImages extends StatelessWidget {
  const EditBookImages({
    required this.icon,
    required this.id,
    this.image,
    super.key,
    this.onTap,
  });
  final File? image;
  final void Function()? onTap;
  final IconData? icon;
  final int id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          border: const DashedBorder.fromBorderSide(
            dashLength: 3,
            side: BorderSide(
              color: Color(0xFFB0BEBF),
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
        ),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
