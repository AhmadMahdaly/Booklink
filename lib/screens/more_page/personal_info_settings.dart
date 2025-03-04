import 'dart:developer';
import 'dart:io';

import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/user/fetch_user_data_cubit.dart';
import 'package:biblio/cubit/user/update_user_image_cubit.dart';
import 'package:biblio/screens/book/add_book_page/widgets/title_form_add_book.dart';
import 'package:biblio/screens/more_page/widgets/get_user_image.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/services/delete_user.dart';
import 'package:biblio/services/error_message.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class PersonalInfoSetting extends StatefulWidget {
  const PersonalInfoSetting({super.key});

  @override
  State<PersonalInfoSetting> createState() => _PersonalInfoSettingState();
}

class _PersonalInfoSettingState extends State<PersonalInfoSetting> {
  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  File? userImage;
  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
      );

      setState(() {
        userImage = File(pickedFile!.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShowPassword = true;

  Future<void> fetchDate() async {
    setState(() {
      _emailController.text = context.read<FetchUserDataCubit>().email;
      _nameController.text = context.read<FetchUserDataCubit>().name;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchUserDataCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          errorMessage(state.message, context);
        }
      },
      builder: (context, state) {
        final fetchUserDateCubit = context.read<FetchUserDataCubit>();
        return BlocConsumer<UpdateUserImageCubit, AppStates>(
          listener: (context, state) {
            if (state is AppErrorState) {
              errorMessage(state.message, context);
            }
          },
          builder: (context, state) {
            final updateUserImageCubit = context.read<UpdateUserImageCubit>();
            return Scaffold(
              appBar: AppBar(
                /// Title
                title: Text(
                  'تعديل البيانات الشخصية',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.71,
                  ),
                ),

                /// Leading
                leading: const LeadingIcon(),
              ),
              body: state is AppLoadingState
                  ? const AppIndicator()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 10.sp,
                      ),
                      child: ListView(
                        children: [
                          /// Upload user image
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleFormAddBook(title: 'الصورة الشخصية'),
                              InkWell(
                                onTap: pickImage,
                                child: Container(
                                  height: 82.sp,
                                  width: 82.sp,
                                  clipBehavior: Clip.antiAlias,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    border: DashedBorder.fromBorderSide(
                                      dashLength: 3,
                                      side: BorderSide(
                                        color: kMainColor,
                                      ),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(320)),
                                  ),
                                  child: userImage == null
                                      ? const GetUserImage()
                                      : Image.file(
                                          userImage!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.sp,
                            height: 16.sp,
                          ),

                          /// Name
                          const TitleFormAddBook(title: 'الاسم'),
                          CustomTextformfield(
                            controller: _nameController,
                            text: _nameController.text,
                          ),

                          /// Email
                          const TitleFormAddBook(title: 'البريد الإلكتروني'),
                          CustomTextformfield(
                            enabled: false,
                            controller: _emailController,
                            text: _emailController.text,
                          ),

                          /// Password
                          const TitleFormAddBook(title: 'كلمة المرور'),
                          CustomTextformfield(
                            controller: _passwordController,
                            icon: IconButton(
                              onPressed: () => setState(
                                () {
                                  isShowPassword = !isShowPassword;
                                },
                              ),
                              icon: isShowPassword
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      size: 24.sp,
                                      color: kHeader1Color,
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      size: 24.sp,
                                      color: kHeader1Color,
                                    ),
                            ),
                            obscureText: isShowPassword,
                          ),

                          /// Delete Account
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.sp),
                            child: const DeleteUser(),
                          ),
                        ],
                      ),
                    ),

              /// Save
              bottomNavigationBar: state is AppLoadingState
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.sp),
                      child: CustomButton(
                        padding: 16,
                        text: 'حفظ',
                        onTap: () async {
                          if (userImage == null) {
                          } else {
                            await updateUserImageCubit.uploadImage(
                              userImage!,
                            );
                          }
                          await fetchUserDateCubit.updateUserData(
                            inName: _nameController.text,
                            inEmail: _emailController.text,
                            inPassword: _passwordController.text,
                          );
                          showSnackBar(context, 'تم الحفظ');

                          await Navigator.pushNamedAndRemoveUntil(
                            context,
                            NavigationBarApp.id,
                            (route) => false,
                          );
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
