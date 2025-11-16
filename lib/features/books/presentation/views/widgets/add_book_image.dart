import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class AddBookImages extends StatelessWidget {
  const AddBookImages({
    required this.icon,
    this.image,
    super.key,
    this.onTap,
  });
  final File? image;
  final void Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 144,
        height: 144,
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
          borderRadius: BorderRadius.all(Radius.circular(15.sp)),
        ),
        child: image != null
            ? Image.file(
                image!,
                fit: BoxFit.cover,
              )
            : Icon(
                icon,
                color: const Color(0xff849090),
              ),
      ),
    );
  }
}
