import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/border_radius.dart';
import 'package:biblio/cubit/favorite_function/favorite_button_cubit.dart';
import 'package:biblio/services/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    required this.bookId,
    super.key,
  });

  final String bookId; // معرّف فريد للكتاب

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteButtonCubit>().loadFavoriteState(
          bookId: widget.bookId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteButtonCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<FavoriteButtonCubit>();
        return state is AppLoadingState
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: const LoadingWidget(
                  size: 10,
                ),
              )
            : InkWell(
                borderRadius: circleBorder(),
                onTap: () => cubit.toggleFavorite(
                  bookId: widget.bookId,
                ),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300), // مدة الانتقال
                  crossFadeState: cubit.isFavorite
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Icon(
                      Icons.bookmark,
                      size: 24.sp,
                      color: kMainColor,
                    ),
                  ), // أيقونة المفضلة
                  secondChild: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Icon(
                      Icons.bookmark_outline,
                      size: 24.sp,
                      color: kMainColor,
                    ),
                  ), // أيقونة غير مفضلة
                ),
              );
      },
    );
  }
}
