import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPageLocation extends StatelessWidget {
  const BookPageLocation({
    required this.book,
    super.key,
  });
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 5.sp,
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 16.sp,
            color: kMainColor,
          ),

          /// Location
          Text(
            ' ${book['country']} - ${book['city']} ',
            style: TextStyle(
              color: kMainColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }
}
