import 'package:intl/intl.dart';

String getTimeDifference(String timestamp) {
  final dateTime =
      DateTime.parse(timestamp).toLocal(); // تحويل UTC إلى التوقيت المحلي
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inHours == 0) {
    // اليوم
    return 'اليوم - ${DateFormat('hh:mm a', 'ar').format(dateTime)}';
  } else if (difference.inDays == 1) {
    // الأمس
    return 'الأمس - ${DateFormat('hh:mm a', 'ar').format(dateTime)}';
  } else if (difference.inDays < 7) {
    // أيام الأسبوع
    return "${DateFormat('EEEE', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
  } else {
    // التاريخ الكامل
    return "${DateFormat('yyyy/MM/dd', 'ar').format(dateTime)} - ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
  }
}
