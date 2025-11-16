import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/features/user_page/presentation/views/fetch_user_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowUserName extends StatelessWidget {
  const ShowUserName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchUserDataCubit, AppStates>(
      builder: (context, state) {
        final cubit = FetchUserDataCubit();
        return SizedBox(
          height: 25.sp,
          child: FutureBuilder<dynamic>(
            future: cubit.fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(
                  size: 10,
                );
              } else if (snapshot.hasError) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                );
              } else {
                final userName = snapshot.data;
                return Text(
                  userName.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
