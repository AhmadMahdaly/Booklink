import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/user/save_user_location_cubit.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectYourLocationScreen extends StatefulWidget {
  const SelectYourLocationScreen({super.key});

  @override
  State<SelectYourLocationScreen> createState() =>
      _SelectYourLocationScreenState();
}

class _SelectYourLocationScreenState extends State<SelectYourLocationScreen> {
  bool isActive = false;
  final List<String> countries = ['مصر', 'السعودية'];
  final Map<String, List<String>> cities = {
    'مصر': [
      'القاهرة',
      'الأسكندرية',
      'الجيزة',
      'بورسعيد',
      'السويس',
      'المنصورة',
      'الزقازيق',
      'طنطا',
      'دمنهور',
      'الفيوم',
      'أسيوط',
      'سوهاج',
      'المنيا',
      'الأقصر',
      'أسوان',
      'قنا',
      'الإسماعيلية',
      'دمياط',
      'بني سويف',
      'مطروح',
      'الغردقة',
      'شرم الشيخ',
    ],
    'السعودية': [
      'الرياض',
      'جدة',
      'مكة المكرمة',
      'المدينة المنورة',
      'الدمام',
      'الخبر',
      'الطائف',
      'بريدة',
      'أبها',
      'خميس مشيط',
      'نجران',
      'حائل',
      'تبوك',
      'جيزان',
      'القطيف',
      'ينبع',
      'العلا',
      'عرعر',
      'سكاكا',
      'الأحساء',
    ],
  };
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveUserLocationCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
        if (state is AppSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            NavigationBarApp.id,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SaveUserLocationCubit>();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const LeadingIcon(),
          ),
          body: state is AppLoadingState
              ? const AppIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Column(
                    spacing: 12.sp,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 6.sp,

                        /// Header
                        children: [
                          Text(
                            'أين تود مشاركة كتبك؟',
                            style: TextStyle(
                              color: kMainColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/books.svg',
                            height: 24.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 351.sp,
                        child: Text(
                          'من فضلك اختار الدولة والمدينة التي تود مشاركة الكتب بها',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const H(h: 5),

                      /// Country
                      Text(
                        'الدولة',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: kLightBlue,
                        decoration: InputDecoration(
                          border: border(),
                          focusedBorder: border(),
                          enabledBorder: border(),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'اختار الدولة',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: kHeader1Color,
                          ),
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        value: cubit.selectedCountry,
                        onChanged: (value) {
                          setState(() {
                            cubit
                              ..selectedCountry = value
                              ..selectedCity =
                                  null; // إعادة ضبط المدينة عند تغيير الدولة
                          });
                        },
                      ),

                      /// City
                      Text(
                        'المدينة',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: kLightBlue,
                        decoration: InputDecoration(
                          border: border(),
                          focusedBorder: border(),
                          enabledBorder: border(),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'اختار المدينة',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: kHeader1Color,
                          ),
                        ),
                        items: cubit.selectedCountry == null
                            ? []
                            : cities[cubit.selectedCountry]!.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                        value: cubit.selectedCity,
                        onChanged: (value) {
                          setState(() {
                            cubit.selectedCity = value;
                            isActive = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),

          /// Button
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 24.sp,
            ),
            child: isActive
                ? CustomButton(
                    text: 'ابدأ التصفح',
                    onTap: cubit.saveUserData,
                  )
                : const CustomButton(
                    text: 'ابدأ التصفح',
                    isActive: false,
                  ),
          ),
        );
      },
    );
  }
}
