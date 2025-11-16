import 'dart:developer';
import 'dart:io';

import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/custom_button.dart';
import 'package:biblio/core/shared_widgets/custom_textformfield.dart';
import 'package:biblio/core/shared_widgets/leading_icon.dart';
import 'package:biblio/core/shared_widgets/show_snackbar.dart';
import 'package:biblio/cubit/books/fetch_category_cubit.dart';
import 'package:biblio/cubit/books/fetch_order_type_book_cubit.dart';
import 'package:biblio/cubit/books/upload_book_cubit.dart';
import 'package:biblio/screens/book/add_book_page/widgets/add_book_image.dart';
import 'package:biblio/screens/book/add_book_page/widgets/title_form_add_book.dart';
import 'package:biblio/screens/navigation_bar/navigation_bar.dart';
import 'package:biblio/screens/onboard/onboard_screen.dart';
import 'package:biblio/services/error_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});
  static String id = 'AddBook';

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isActive = false;
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conditionController = TextEditingController();
  final _priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedCategory;
  List<String> categories = [];
  String? selectedOffer;
  List<String> offerTypes = [];

  File? coverFirstImage;
  File? coverSecondImage;

  /// Pick 1st image
  Future<void> pickFirstImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        imageQuality: 30,
        source: ImageSource.gallery,
      );
      setState(() {
        coverFirstImage = File(pickedFile!.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  /// Pick 2nd image
  Future<void> pickSocendImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        imageQuality: 30,
        source: ImageSource.gallery,
      );
      setState(() {
        coverSecondImage = File(pickedFile!.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  // Future getImageTotext(String imagePath) async {
  //   final textRecognizer = TextRecognizer();
  //   final recognizedText =
  //       await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  //   final text = recognizedText.text;
  //   return text;
  // }
  // late String s = '';

  @override
  Widget build(BuildContext context) {
    // final picker = ImagePicker();
    String? user;
    if (Supabase.instance.client.auth.currentUser?.id == null) {
      user = null;
    } else {
      user = Supabase.instance.client.auth.currentUser?.id;
    }
    if (coverFirstImage == null ||
        coverSecondImage == null ||
        _titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        selectedCategory == null ||
        _conditionController.text.isEmpty ||
        selectedOffer == null) {
      if (mounted) {
        setState(() {
          isActive = false;
        });
      }
    } else {
      setState(() {
        isActive = true;
      });
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchBookCategoryCubit>(
          create: (context) => FetchBookCategoryCubit(),
        ),
        BlocProvider<FetchOrderTypeBookCubit>(
          create: (context) => FetchOrderTypeBookCubit(),
        ),
      ],
      child: BlocConsumer<UploadBookCubit, AppStates>(
        listener: (context, state) {
          if (state is AppErrorState) {
            errorMessage(state.message, context);
          }
          if (state is AppSuccessState) {
            FetchBookCategoryCubit().close();
            FetchOrderTypeBookCubit().close();
            Navigator.pushReplacementNamed(context, NavigationBarApp.id);
          }
        },
        builder: (context, state) {
          context
            ..read<FetchBookCategoryCubit>().fetchCategories()
            ..read<FetchOrderTypeBookCubit>().fetchOrderType(context);
          final uploadCubit = context.read<UploadBookCubit>();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 80.sp,
              leading: const LeadingIcon(),
              title: Text(
                'AddBook'.tr(),
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: state is AppLoadingState
                ? const LoadingWidget()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          Text(
                            'AddTwoImg'.tr(),
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            spacing: 12.sp,
                            children: [
                              AddBookImages(
                                icon: Icons.image_outlined,
                                image: coverFirstImage,
                                onTap: pickFirstImage,
                              ),
                              AddBookImages(
                                icon: Icons.image_outlined,
                                image: coverSecondImage,
                                onTap: pickSocendImage,
                              ),
                            ],
                          ),
                          TitleFormAddBook(
                            title: 'Book name'.tr(),
                          ),
                          CustomTextformfield(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required data'.tr();
                              }
                              return null;
                            },
                            text: '${'Example'.tr()}: ${'BookNameExmple'.tr()}',
                            controller: _titleController,
                          ),
                          TitleFormAddBook(title: "Author's name".tr()),
                          CustomTextformfield(
                            text: '${'Example'.tr()}: ${'WritterExmple'.tr()}',
                            controller: _authorController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required data'.tr();
                              }
                              return null;
                            },
                          ),
                          TitleFormAddBook(title: 'Book category'.tr()),
                          BlocConsumer<FetchBookCategoryCubit, AppStates>(
                            listener: (context, state) {
                              if (state is AppErrorState) {
                                errorMessage(state.message, context);
                              }
                            },
                            builder: (context, state) {
                              final cubit =
                                  context.read<FetchBookCategoryCubit>();
                              return DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required data'.tr();
                                  }
                                  return null;
                                },
                                icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 16.sp,
                                  ),
                                ),
                                elevation: 5,
                                dropdownColor: kLightBlue,
                                initialValue: cubit.selectedCategory,
                                items: cubit.categories
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    cubit.selectedCategory = value;
                                    selectedCategory = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'ChooseCategory'.tr(),
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: kTextShadowColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: border(),
                                  focusedBorder: border(),
                                  enabledBorder: border(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.sp),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          TitleFormAddBook(title: 'About the book'.tr()),
                          CustomTextformfield(
                            // icon: GestureDetector(
                            //   onTap: () async {
                            //     final image = await picker.pickImage(
                            //       source: ImageSource.gallery,
                            //     );
                            //     if (image != null) {
                            //       final a = await getImageTotext(image.path);
                            //       setState(() {
                            //         s = a.toString();
                            //       });
                            //     }
                            //   },
                            //   child: const Icon(
                            //     Icons.copy_all_outlined,
                            //   ),
                            // ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required data'.tr();
                              }
                              return null;
                            },
                            maxLines: 100,
                            text: '',
                            contentPadding: EdgeInsets.only(
                              bottom: 56.sp,
                              right: 12.sp,
                              left: 12.sp,
                              top: 12.sp,
                            ),
                            controller: _descriptionController,
                          ),
                          TitleFormAddBook(title: 'Book condition'.tr()),
                          CustomTextformfield(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required data'.tr();
                              }
                              return null;
                            },
                            text: 'Used, new, in good condition...etc'.tr(),
                            controller: _conditionController,
                          ),
                          TitleFormAddBook(title: 'OfferType'.tr()),
                          BlocConsumer<FetchOrderTypeBookCubit, AppStates>(
                            listener: (context, state) {
                              if (state is AppErrorState) {
                                errorMessage(state.message, context);
                              }
                            },
                            builder: (context, state) {
                              final cubit =
                                  context.read<FetchOrderTypeBookCubit>();
                              return DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required data'.tr();
                                  }
                                  return null;
                                },
                                icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 16.sp,
                                  ),
                                ),
                                elevation: 5,
                                dropdownColor: kLightBlue,
                                initialValue: cubit.selectedOffer,
                                items: cubit.offerTypes
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    cubit.selectedOffer = value;
                                    selectedOffer = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Choose the type of offer'.tr(),
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: kTextShadowColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: border(),
                                  focusedBorder: border(),
                                  enabledBorder: border(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.sp),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (context
                                  .read<FetchOrderTypeBookCubit>()
                                  .selectedOffer ==
                              'For sale'.tr())
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TitleFormAddBook(title: 'Price'.tr()),
                                CustomTextformfield(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required data'.tr();
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  text: '${'Example'.tr()}: 10',
                                  controller: _priceController,
                                ),
                              ],
                            )
                          else
                            const SizedBox(),
                          16.verticalSpace,
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: state is AppLoadingState
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: user == null
                        ? CustomBorderBotton(
                            text: 'Login'.tr(),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                OnboardScreen.id,
                              );
                            },
                          )
                        : isActive
                            ? CustomButton(
                                text: 'Add the book'.tr(),
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      await uploadCubit.uploadBook(
                                        title: _titleController.text,
                                        author: _authorController.text,
                                        desc: _descriptionController.text,
                                        state: _conditionController.text,
                                        price: _priceController.text,
                                        selectedCategory: selectedCategory!,
                                        selectedOffer: selectedOffer!,
                                        coverFirstImage: coverFirstImage!,
                                        coverSecondImage: coverSecondImage!,
                                      );
                                    } catch (e) {
                                      showSnackBar(
                                        context,
                                        'AddBookError'.tr(),
                                      );
                                    }
                                  }
                                },
                              )
                            : CustomButton(
                                isActive: false,
                                text: 'Add the book'.tr(),
                              ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _conditionController.dispose();
    _priceController.dispose();

    super.dispose();
  }
}
