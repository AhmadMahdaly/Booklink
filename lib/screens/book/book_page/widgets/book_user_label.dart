import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/screens/user_page/user_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookUserLabel extends StatelessWidget {
  const BookUserLabel({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 5.sp,
      ),
      child: InkWell(
        highlightColor: kDisableButtonColor,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(book: book),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5.sp,
          children: [
            if (book['user_image'] == null ||
                book['user_image'].toString().isEmpty)
              Icon(
                Icons.account_circle,
                size: 30.sp,
                color: kScaffoldBackgroundColor,
              )
            else
              Container(
                height: 32.sp,
                width: 32.sp,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(320),
                ),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) =>
                      LoadingWidget(
                    size: 10.sp,
                  ),
                  imageUrl: book['user_image'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              child: Text(
                book['user_name'].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: kMainColor,
                  height: 0.71,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
