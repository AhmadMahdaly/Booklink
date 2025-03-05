import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/width.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowBook extends StatelessWidget {
  const ShowBook({
    required this.book,
    super.key,
  });

  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.symmetric(horizontal: 8.sp),
          width: 140.sp,
          height: 220.sp,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              onError: (exception, stackTrace) => const Icon(Icons.error),

              /// Book Cover
              image: NetworkImage(
                book['cover_image_url'].toString(),
              ),
            ),
            borderRadius: BorderRadius.circular(20.sp),
            color: const Color(0xFFF7F7F7),
          ),

          /// Label of user
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                width: 100.sp,
                height: 24.sp,
                child: Row(
                  children: [
                    const W(w: 3),

                    /// User image
                    if (book['user_image'] == null ||
                        book['user_image'].toString().isEmpty)
                      Icon(
                        Icons.account_circle,
                        size: 20.sp,
                        color: kScaffoldBackgroundColor,
                      )
                    else
                      Container(
                        height: 20.sp,
                        width: 20.sp,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(320),
                        ),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              AppIndicator(
                            size: 10.sp,
                          ),
                          imageUrl: book['user_image'].toString(),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    const W(w: 3),

                    /// User Name
                    SizedBox(
                      width: 70.sp,
                      child: Text(
                        book['user_name'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF3A3A3A),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Book Name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: SizedBox(
            width: 140.sp,
            child: Text(
              book['title'].toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        /// Writter Name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: SizedBox(
            width: 140.sp,
            child: Text(
              book['author'].toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF969697),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
