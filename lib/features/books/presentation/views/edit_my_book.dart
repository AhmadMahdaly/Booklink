import 'dart:io';

import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/core/shared_widgets/app_indicator.dart';
import 'package:biblio/core/shared_widgets/custom_button.dart';
import 'package:biblio/core/shared_widgets/custom_textformfield.dart';
import 'package:biblio/features/books/presentation/controllers/update_book_cubit.dart';
import 'package:biblio/features/books/presentation/views/widgets/get_book_image.dart';
import 'package:biblio/features/books/presentation/views/widgets/title_form_add_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBook extends StatefulWidget {
  const EditBook({super.key});
  static String id = 'EditBook';

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final supabase = Supabase.instance.client;
  bool isActive = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late int bookId = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

      setState(() {
        bookId = args['bookId'] as int;
        context.read<UpdateBookCubit>().initializeData(bookId);
      });
    });
  }

  File? _coverImage;
  File? _coverImageI;

  /// Pick 1st image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      imageQuality: 20,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  /// Pick 2nd image
  Future<void> _pickImageI() async {
    final pickedFile = await ImagePicker().pickImage(
      imageQuality: 20,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _coverImageI = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    /// رفع الصورة إلى Supabase Storage
    final fileName = 'books/${DateTime.now().toIso8601String()}';
    final fileNameI = 'books/${DateTime.now().toIso8601String()}';
    if (_coverImage != null) {
      await supabase.storage.from('book_covers').upload(
            fileName,
            _coverImage!,
          );

      final imageUrl =
          supabase.storage.from('book_covers').getPublicUrl(fileName);

      /// حفظ رابط الصورة في جدول books
      await supabase.from('books').update({
        'cover_image_url': imageUrl,
      }).eq('id', bookId);

      await supabase.from('conversation_participants').update({
        'book_image': imageUrl,
      }).eq('book_id', bookId);
    } else if (_coverImageI != null) {
      await supabase.storage.from('book_covers').upload(
            fileNameI,
            _coverImageI!,
          );
      final imageUrlI =
          supabase.storage.from('book_covers').getPublicUrl(fileNameI);
      await supabase.from('books').update({
        'cover_book_url2': imageUrlI,
      }).eq('id', bookId);
    }
  }

  String? selectedCategory;
  String? selectedOffer;

  // Future getImageTotext(String imagePath) async {
  //   final textRecognizer = TextRecognizer();
  //   final recognizedText =
  //       await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  //   final text = recognizedText.text;
  //   return text;
  // }
  // late String s = '';
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _conditionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final picker = ImagePicker();
    return BlocBuilder<UpdateBookCubit, AppStates>(
      builder: (context, state) {
        final cubit = context.read<UpdateBookCubit>();
        _titleController.text = cubit.titleController;
        _authorController.text = cubit.authorController;
        _descriptionController.text = cubit.descriptionController;
        _conditionController.text = cubit.conditionController;
        priceController.text = cubit.priceController;
        selectedCategory = cubit.selectedCategory;
        selectedOffer = cubit.selectedOffer;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kMainColor,
                size: 22.sp,
              ),
            ),
            title: Text(
              'تعديل الكتاب',
              style: TextStyle(
                color: kMainColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
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
                        /// Images book
                        Text(
                          'تعديل صورتي للكتاب',
                          textAlign: TextAlign.right,
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
                            if (_coverImage == null)
                              GetBookImage(
                                onTap: _pickImage,
                                id: bookId,
                              )
                            else
                              Container(
                                width: 144.w,
                                height: 144.h,
                                clipBehavior: Clip.antiAlias,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECECEC),
                                  border: const DashedBorder.fromBorderSide(
                                    dashLength: 3,
                                    side: BorderSide(
                                      color: Color(0xFFB0BEBF),
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.sp)),
                                ),
                                child: Image.file(
                                  _coverImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (_coverImageI == null)
                              GetBookImageI(
                                onTap: _pickImageI,
                                id: bookId,
                              )
                            else
                              Container(
                                width: 144.w,
                                height: 144.h,
                                clipBehavior: Clip.antiAlias,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECECEC),
                                  border: const DashedBorder.fromBorderSide(
                                    dashLength: 3,
                                    side: BorderSide(
                                      color: Color(0xFFB0BEBF),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.sp),
                                  ),
                                ),
                                child: Image.file(
                                  _coverImageI!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),

                        /// Book name
                        const TitleFormAddBook(
                          title: 'اسم الكتاب',
                        ),
                        CustomTextformfield(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البيانات المطلوبة';
                            }
                            return null;
                          },
                          controller: _titleController,
                          text: _titleController.text,
                        ),

                        /// Writter Name
                        const TitleFormAddBook(title: 'اسم الكاتب'),
                        CustomTextformfield(
                          controller: _authorController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البيانات المطلوبة';
                            }
                            return null;
                          },
                        ),

                        /// Category
                        const TitleFormAddBook(title: 'فئة الكتاب'),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البيانات المطلوبة';
                            }
                            return null;
                          },
                          hint: Text(
                            selectedCategory ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: kTextShadowColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          icon: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 16.sp,
                            ),
                          ),
                          elevation: 5,
                          dropdownColor: kLightBlue,
                          initialValue: selectedCategory,
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
                              selectedCategory = value;
                            });
                          },
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
                          ),
                        ),

                        /// Desc
                        const TitleFormAddBook(title: 'نبذة عن الكتاب'),
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
                              return 'ادخل البيانات المطلوبة';
                            }
                            return null;
                          },
                          maxLines: 100,
                          contentPadding: EdgeInsets.only(
                            bottom: 56.sp,
                            right: 12.sp,
                            left: 12.sp,
                            top: 12.sp,
                          ),
                          controller: _descriptionController,
                        ),

                        /// Condition
                        const TitleFormAddBook(title: 'حالة الكتاب'),
                        CustomTextformfield(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البيانات المطلوبة';
                            }
                            return null;
                          },
                          controller: _conditionController,
                        ),

                        /// Offer Type
                        const TitleFormAddBook(title: 'نوع العرض'),
                        DropdownButtonFormField<String>(
                          hint: Text(
                            selectedOffer ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: kTextShadowColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البيانات المطلوبة';
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
                          initialValue: selectedOffer,
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
                              selectedOffer = value;
                            });
                          },
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
                          ),
                        ),

                        /// Price
                        if (cubit.selectedOffer == 'للبيع')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const TitleFormAddBook(title: 'السعر'),
                              CustomTextformfield(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ادخل البيانات المطلوبة';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: priceController,
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

          /// Edit Button
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16.sp),
            child: CustomButton(
              text: 'تعديل الكتاب',
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  await _uploadImage();
                  await cubit.updateBook(
                    bookId: bookId.toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    author: _authorController.text,
                    category: cubit.selectedCategory,
                    condition: _conditionController.text,
                    offerType: cubit.selectedOffer,
                    price: int.tryParse(priceController.text)!,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
