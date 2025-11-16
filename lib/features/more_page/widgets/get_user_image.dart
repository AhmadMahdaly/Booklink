import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/features/user_page/presentation/views/fetch_user_data_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetUserImage extends StatelessWidget {
  const GetUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 80;
    const indicatorSize = 10;
    return BlocBuilder<FetchUserDataCubit, AppStates>(
      builder: (context, state) {
        final cubit = FetchUserDataCubit();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.sp,
              height: size.sp,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(320),
              ),
              child: FutureBuilder<String?>(
                future: cubit.getUserPhoto(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget(
                      size: indicatorSize.sp,
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  final photoUrl = snapshot.data;
                  if (photoUrl == null || photoUrl.isEmpty) {
                    return Icon(
                      Icons.account_circle,
                      size: 80.sp,
                      color: kMainColor,
                    );
                  }
                  return CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    progressIndicatorBuilder: (context, url, progress) =>
                        LoadingWidget(
                      size: indicatorSize.sp,
                    ),
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
