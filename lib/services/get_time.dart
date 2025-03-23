import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String getTimeDifference(String timestamp, BuildContext context) {
  final dateTime =
      DateTime.parse(timestamp).toLocal(); // تحويل UTC إلى التوقيت المحلي
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inHours == 0) {
    // اليوم
    if (context.locale == const Locale('ar')) {
      return 'اليوم - ${DateFormat('hh:mm a', 'ar').format(dateTime)}';
    } else {
      return 'Today - ${DateFormat('hh:mm a', 'en').format(dateTime)}';
    }
  } else if (difference.inDays == 1) {
    // الأمس
    if (context.locale == const Locale('ar')) {
      return 'الأمس - ${DateFormat('hh:mm a', 'ar').format(dateTime)}';
    } else {
      return 'Yesterday - ${DateFormat('hh:mm a', 'en').format(dateTime)}';
    }
  } else if (difference.inDays < 7) {
    // أيام الأسبوع
    if (context.locale == const Locale('ar')) {
      return "${DateFormat('EEEE', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else {
      return "${DateFormat('EEEE', 'en').format(dateTime)} - ${DateFormat('hh:mm a', 'en').format(dateTime)}";
    }
  } else {
    // التاريخ الكامل
    if (context.locale == const Locale('ar')) {
      return "${DateFormat('yyyy/MM/dd', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else {
      return "${DateFormat('yyyy/MM/dd', 'en').format(dateTime)} - ${DateFormat('hh:mm a', 'en').format(dateTime)}";
    }
  }
}
