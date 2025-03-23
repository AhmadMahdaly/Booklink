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
import 'package:easy_localization/easy_localization.dart';
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
                            'WhereYouShareBook'.tr(),
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
                          'ChooseCountryAndCity'.tr(),
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
                        'Country'.tr(),
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
                          hintText: 'ChooseCountry'.tr(),
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
                        'City'.tr(),
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
                          hintText: 'ChooseCity'.tr(),
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
                    text: 'Start'.tr(),
                    onTap: cubit.saveUserData,
                  )
                : CustomButton(
                    text: 'Start'.tr(),
                    isActive: false,
                  ),
          ),
        );
      },
    );
  }
}
  //  "Egypt": "مصر",
  //   "Cairo": "القاهرة",
  //   "Alexandria": "الأسكندرية",
  //   "Giza": "الجيزة",
  //   "Port Said": "بورسعيد",
  //   "Suez": "السويس",
  //   "Mansoura": "المنصورة",
  //   "Zagazig": "الزقازيق",
  //   "Tanta": "طنطا",
  //   "Damanhur": "دمنهور",
  //   "Fayoum": "الفيوم",
  //   "Asyut": "أسيوط",
  //   "Sohag": "سوهاج",
  //   "Minya": "المنيا",
  //   "Luxor": "الأقصر",
  //   "Aswan": "أسوان",
  //   "Qena": "قنا",
  //   "Ismailia": "الإسماعيلية",
  //   "Damietta": "دمياط",
  //   "Beni Suef": "بني سويف",
  //   "Matrouh": "مطروح",
  //   "Hurghada": "الغردقة",
  //   "Sharm El-Sheikh": "شرم الشيخ",
  //   "Saudi Arabia": "السعودية",
  //   "Riyadh": "الرياض",
  //   "Jeddah": "جدة",
  //   "Mecca": "مكة المكرمة",
  //   "Medina": "المدينة المنورة",
  //   "Dammam": "الدمام",
  //   "Khobar": "الخبر",
  //   "Taif": "الطائف",
  //   "Buraidah": "بريدة",
  //   "Abha": "أبها",
  //   "Khamis Mushait": "خميس مشيط",
  //   "Najran": "نجران",
  //   "Hail": "حائل",
  //   "Tabuk": "تبوك",
  //   "Jizan": "جيزان",
  //   "Qatif": "القطيف",
  //   "Yanbu": "ينبع",
  //   "AlUla": "العلا",
  //   "Arar": "عرعر",
  //   "Sakaka": "سكاكا",
  //   "Al-Ahsa": "الأحساء",
    //   "Egypt": "Egypt",
    // "Cairo": "Cairo",
    // "Alexandria": "Alexandria",
    // "Giza": "Giza",
    // "Port Said": "Port Said",
    // "Suez": "Suez",
    // "Mansoura": "Mansoura",
    // "Zagazig": "Zagazig",
    // "Tanta": "Tanta",
    // "Damanhur": "Damanhur",
    // "Fayoum": "Fayoum",
    // "Asyut": "Asyut",
    // "Sohag": "Sohag",
    // "Minya": "Minya",
    // "Luxor": "Luxor",
    // "Aswan": "Aswan",
    // "Qena": "Qena",
    // "Ismailia": "Ismailia",
    // "Damietta": "Damietta",
    // "Beni Suef": "Beni Suef",
    // "Matrouh": "Matrouh",
    // "Hurghada": "Hurghada",
    // "Sharm El-Sheikh": "Sharm El-Sheikh",
    // "Saudi Arabia": "Saudi Arabia",
    // "Riyadh": "Riyadh",
    // "Jeddah": "Jeddah",
    // "Mecca": "Mecca",
    // "Medina": "Medina",
    // "Dammam": "Dammam",
    // "Khobar": "Khobar",
    // "Taif": "Taif",
    // "Buraidah": "Buraidah",
    // "Abha": "Abha",
    // "Khamis Mushait": "Khamis Mushait",
    // "Najran": "Najran",
    // "Hail": "Hail",
    // "Tabuk": "Tabuk",
    // "Jizan": "Jizan",
    // "Qatif": "Qatif",
    // "Yanbu": "Yanbu",
    // "AlUla": "AlUla",
    // "Arar": "Arar",
    // "Sakaka": "Sakaka",
    // "Al-Ahsa": "Al-Ahsa"
    
