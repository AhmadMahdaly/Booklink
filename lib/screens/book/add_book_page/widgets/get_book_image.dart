import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetBookImage extends StatelessWidget {
  const GetBookImage({
    required this.id,
    required this.onTap,
    super.key,
  });
  final int id;
  final void Function()? onTap;

  /// Get book photo
  Future<String?> getBooksPhoto(
    int id,
  ) async {
    final supabase = Supabase.instance.client;
    try {
      /// استرجاع رابط الصورة من قاعدة البيانات
      final response = await supabase
          .from('books')
          .select('cover_image_url')
          .eq('id', id)
          .single();

      /// استخراج رابط الصورة
      final photoUrl = response['cover_image_url'] as String;
      return photoUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 144,
        height: 144,
        clipBehavior: Clip.antiAlias,
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
        child: FutureBuilder<String?>(
          future: getBooksPhoto(
            id,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingWidget(
                  size: 10.sp,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('WrongError'.tr()));
            }
            final photoUrl = snapshot.data;

            return CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) =>
                  LoadingWidget(
                size: 10.sp,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: photoUrl!,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class GetBookImageI extends StatelessWidget {
  const GetBookImageI({
    required this.id,
    required this.onTap,
    super.key,
  });
  final int id;

  final void Function()? onTap;
  Future<String?> getBooksPhotoI(
    int id,
  ) async {
    final supabase = Supabase.instance.client;
    try {
      /// استرجاع رابط الصورة من قاعدة البيانات
      final response = await supabase
          .from('books')
          .select('cover_book_url2')
          .eq('id', id)
          .single();

      /// استخراج رابط الصورة
      final photoUrl = response['cover_book_url2'] as String;
      return photoUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 144,
        height: 144,
        clipBehavior: Clip.antiAlias,
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
        child: FutureBuilder<String?>(
          future: getBooksPhotoI(
            id,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingWidget(
                  size: 10.sp,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('WrongError'.tr()));
            }
            final photoUrl = snapshot.data;

            return CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) =>
                  LoadingWidget(
                size: 10.sp,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: photoUrl!,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
