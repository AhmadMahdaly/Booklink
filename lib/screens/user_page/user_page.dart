import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/user/get_user_qty_books_cubit.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  const UserPage({required this.book, super.key});
  final Map<String, dynamic> book;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    context
        .read<GetUserQtyBooksCubit>()
        .getUserQTYbooks(widget.book['user_id'].toString(), context);
    super.initState();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(
      _url,
    )) {
      throw Exception(
        'Could not launch $_url',
      );
    }
  }

  late final Uri _url = Uri.parse(
    widget.book['location_url'].toString(),
  );
  @override
  Widget build(BuildContext context) {
    String getTimeDifference() {
      final now = DateTime.now();
      final specificDate = widget.book['user_created_at'];
      final createdAt = DateTime.parse(specificDate.toString());
      final difference = now.difference(createdAt);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ساعة';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} يوم';
      } else {
        return DateFormat('yyyy-MM').format(createdAt); // تاريخ واضح
      }
    }

    return BlocConsumer<GetUserQtyBooksCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<GetUserQtyBooksCubit>();

        return Scaffold(
          appBar: AppBar(
            /// Leading
            leading: const LeadingIcon(),
          ),
          body: state is AppLoadingState
              ? const AppIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.sp,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Spacer(),
                          if (widget.book['user_image'] == null ||
                              widget.book['user_image'].toString().isEmpty)
                            Icon(
                              Icons.account_circle,
                              size: 150.sp,
                              color: kScaffoldBackgroundColor,
                            )
                          else
                            Container(
                              height: 150.sp,
                              width: 150.sp,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(320),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                progressIndicatorBuilder:
                                    (context, url, progress) => AppIndicator(
                                  size: 10.sp,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 20,
                                  color: kMainColor,
                                ),
                                imageUrl: widget.book['user_image'].toString(),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.sp),
                            child: Text(
                              textAlign: TextAlign.center,
                              'الصورة\nالشخصية',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const H(h: 28),
                      SizedBox(
                        child: Text(
                          widget.book['user_name'].toString(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: kTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16.sp,
                              color: kMainColor,
                            ),

                            /// Location
                            Text(
                              ' ${widget.book['country']} - ${widget.book['city']} ',
                              style: TextStyle(
                                color: kMainColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'انضم للمكتبة منذ ${getTimeDifference()}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: kTextColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'عدد الكتب: ${cubit.qtyBooks.length}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: kTextColor,
                          ),
                        ),
                      ),
                      if (widget.book['fav_location'] == null ||
                          widget.book['fav_location'].toString().isEmpty)
                        const SizedBox()
                      else
                        widget.book['location_url'] == null ||
                                widget.book['location_url'].toString().isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'أماكن اللقاء المفضلة: ',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const H(h: 6),
                                  SizedBox(
                                    width: 330.sp,
                                    child: Text(
                                      '${widget.book['fav_location']}',
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      'أماكن اللقاء المفضلة: ',
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const H(h: 6),
                                    InkWell(
                                      onTap: _launchUrl,
                                      child: SizedBox(
                                        width: 330.sp,
                                        child: Text(
                                          '${widget.book['fav_location']}',
                                          style: TextStyle(
                                            color: kTextColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
