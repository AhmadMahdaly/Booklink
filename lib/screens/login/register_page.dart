import 'package:biblio/cubit/app_states.dart';
import 'package:biblio/cubit/auth_cubit/auth_cubit.dart';
import 'package:biblio/screens/login/login_screen.dart';
import 'package:biblio/screens/more_page/widgets/terms_and_conditions_page.dart';
import 'package:biblio/screens/select_your_location_screen.dart';
import 'package:biblio/services/emailjs.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'SignUpScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isShowPassword = true;
  bool _isAgreed = false;
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessState) {
          showSnackBar(
            context,
            'تم التسجيل',
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SelectYourLocationScreen();
              },
            ),
          );
          sendEmail(
            _emailController.text,
            'Welcome to Our App',
            'Your account has been created successfully!',
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is AppLoadingState
              ? const AppIndicator()
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),

                      /// Form
                      child: Form(
                        key: formKey,
                        child: Column(
                          spacing: 12.sp,
                          children: [
                            /// Header
                            const H(h: 50),
                            SvgPicture.asset(
                              'assets/svg/logo.svg',
                              colorFilter: const ColorFilter.mode(
                                kMainColor,
                                BlendMode.srcIn,
                              ),
                              width: 105.sp,
                            ),
                            Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                color: kMainColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const H(h: 2),

                            /// Name
                            Row(
                              children: [
                                Text(
                                  'الاسم',
                                  style: TextStyle(
                                    color: kHeader1Color,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextformfield(
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              text: 'الاسم',
                              controller: _userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            ),

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
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              controller: _emailController,
                              text: 'البريد الإلكتروني',
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

                            Row(
                              children: [
                                Checkbox(
                                  activeColor: kMainColor,
                                  value: _isAgreed,
                                  onChanged: (value) {
                                    setState(() {
                                      enabled = value ?? false;
                                      _isAgreed = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsAndConditionsPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'أوافق على الشروط والأحكام',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: kMainColor,
                                        color: kMainColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              spacing: 8.sp,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Sign up Button
                                CustomButton(
                                  isActive: enabled,
                                  text: 'إنشاء الحساب',
                                  padding: 16,
                                  onTap: _isAgreed
                                      ? () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            await cubit.signUp(
                                              name: _userNameController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              context: context,
                                            );
                                          }
                                        }
                                      : () {},
                                ),
                                const H(h: 0),
                                Row(
                                  spacing: 16.sp,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'أو قم بالتسجيل عبر',
                                      style: TextStyle(
                                        color: kHeader1Color,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        cubit.googleSignUp(context);
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

                                /// Login
                                InkWell(
                                  onTap: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      LoginScreen.id,
                                    );
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'لديك حساب بالفعل؟ ',
                                          style: TextStyle(
                                            color: kHeader1Color,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'تسجيل الدخول',
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
                                const H(h: 16),
                              ],
                            ),
                          ],
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
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
