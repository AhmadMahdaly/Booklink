import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/auth_cubit/auth_cubit.dart';
import 'package:biblio/screens/login/register_page.dart';
import 'package:biblio/screens/login/widgets/forget_password_screen.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/app_regex.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AppStates>(
      listener: (context, state) {
        if (state is AppErrorState) {
          if (state.message == 'Connection refused' ||
              state.message == 'Connection reset by peer') {
            showSnackBar(context, 'لا يوجد اتصال بالانترنت');
          } else {
            showSnackBar(context, state.message);
          }
        }
        if (state is AppSuccessState) {
          Navigator.pushReplacementNamed(
            context,
            NavigationBarApp.id,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Scaffold(
          body: state is AppLoadingState
              ? const AppIndicator()
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: AutofillGroup(
                        child: Form(
                          key: formKey,
                          child: Column(
                            spacing: 16.sp,
                            children: [
                              /// Header
                              const H(h: 70),
                              SvgPicture.asset(
                                'assets/svg/logo.svg',
                                colorFilter: const ColorFilter.mode(
                                  kMainColor,
                                  BlendMode.srcIn,
                                ),
                                width: 115.sp,
                              ),
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const H(h: 4),

                              /// Email
                              Row(
                                children: [
                                  Text(
                                    'البريد الإلكتروني',
                                    style: TextStyle(
                                      color: kHeader1Color,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextformfield(
                                controller: _emailController,
                                text: 'البريد الإلكتروني',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                validator: (value) {
                                  if (!AppRegex.isEmailValid(
                                    _emailController.text,
                                  )) {
                                    return 'هذا البريد الإلكتروني غير صالح';
                                  }
                                  return null;
                                },
                              ),

                              /// Password
                              Row(
                                children: [
                                  Text(
                                    'كلمة المرور',
                                    style: TextStyle(
                                      color: kHeader1Color,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextformfield(
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return 'كلمة المرور غير صالحة';
                                  }
                                  return null;
                                },
                                text: 'كلمة المرور',

                                /// Check show password
                                icon: IconButton(
                                  onPressed: () => setState(() {
                                    isShowPassword = !isShowPassword;
                                  }),
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

                              /// Forget password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgetPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                        color: const Color(0xFF3E5879),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: kMainColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const H(h: 10),

                              /// Login Button
                              CustomButton(
                                text: 'تسجيل الدخول',
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    await cubit.login(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    //     try {
                                    //       final response = await signIn();
                                    //       setState(() {
                                    //         isInAsyncCall = false;
                                    //         userId = response.user!.id;
                                    //         Navigator.pushReplacementNamed(
                                    //           context,
                                    //           NavigationBarApp.id,
                                    //         );
                                    //       });
                                    //     } on AuthException catch (error) {
                                    //       setState(() {
                                    //         isInAsyncCall = false;
                                    //       });
                                    //       if (error.message ==
                                    //           'Invalid login credentials') {
                                    //         showSnackBar(
                                    //           context,
                                    //           'بيانات تسجيل الدخول غير صحيحة',
                                    //         );
                                    //       } else if (error.message ==
                                    //           'Email is not valid') {
                                    //         showSnackBar(
                                    //           context,
                                    //           'البريد الإلكتروني غير صالح',
                                    //         );
                                    //       } else if (error.message ==
                                    //           'Password is not valid') {
                                    //         showSnackBar(
                                    //           context,
                                    //           'كلمة المرور غير صالحة',
                                    //         );
                                    //       } else if (error.message == 'User not found') {
                                    //         showSnackBar(
                                    //           context,
                                    //           'المستخدم غير موجود',
                                    //         );
                                    //       } else if (error.message ==
                                    //           'Password should be at least 6 characters') {
                                    //         showSnackBar(
                                    //           context,
                                    //           'كلمة المرور ضعيفة',
                                    //         );
                                    //       }
                                    //     } catch (e) {
                                    //       setState(() {
                                    //         isInAsyncCall = false;
                                    //       });
                                    //       showSnackBar(
                                    //         context,
                                    //         'أوبس، هناك خطأ في تسجيل الدخول! ربما يكون هناك مشكلة في الإتصال.\n$e',
                                    //       );
                                    //     }
                                  }
                                },
                              ),
                              Row(
                                spacing: 12.sp,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'أو قم بتسجيل الدخول عبر',
                                    style: TextStyle(
                                      color: const Color(0xFF3E5879),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cubit.googleSignIn(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 15.sp,
                                      backgroundColor: kMainColor,
                                      child: CircleAvatar(
                                        radius: 14.sp,
                                        backgroundColor:
                                            kScaffoldBackgroundColor,
                                        child: SizedBox(
                                          height: 20.sp,
                                          child: Image.asset(
                                            'assets/icons/google-symbol.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// Sign Up
                              InkWell(
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                    context,
                                    RegisterScreen.id,
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'ليس لديك حساب؟ ',
                                        style: TextStyle(
                                          color: kHeader1Color,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'أنشىء حسابك الآن',
                                        style: TextStyle(
                                          color: const Color(0xFF3E5879),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
