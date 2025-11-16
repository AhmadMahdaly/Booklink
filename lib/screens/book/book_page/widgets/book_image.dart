import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/border_radius.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPageImage extends StatelessWidget {
  const BookPageImage({
    required this.book,
    super.key,
  });

  final Map<String, dynamic> book;

  @override
  Widget build(BuildContext context) {
    final images = <String>[
      book['cover_image_url'].toString(),
      book['cover_book_url2'].toString(),
    ];
    return Container(
      width: 220.sp,
      height: 325.sp,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius(),
      ),
      child: CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder: (
          BuildContext context,
          int index,
          int pageViewIndex,
        ) =>
            Container(
          width: 250.sp,
          height: 325.sp,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: borderRadius(),
          ),
          child: CachedNetworkImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const LoadingWidget();
            },
            errorWidget: (context, url, error) {
              return const Icon(
                Icons.broken_image_outlined,
              );
            },
          ),
        ),
        options: CarouselOptions(
          viewportFraction: 0.7,
          enableInfiniteScroll: false,
          // autoPlay: true,
          height: double.infinity,
          enlargeCenterPage: true,
        ),
      ),
    );
  }
}
