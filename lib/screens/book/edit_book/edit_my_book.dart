import 'dart:io';

import 'package:biblio/screens/book/add_book_page/widgets/get_book_image.dart';
import 'package:biblio/screens/book/add_book_page/widgets/title_form_add_book.dart';
import 'package:biblio/services/update_my_book.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/components/custom_button.dart';
import 'package:biblio/utils/components/custom_textformfield.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:biblio/utils/components/show_snackbar.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBook extends StatefulWidget {
  const EditBook({super.key});
  static String id = 'EditBook';

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final supabase = Supabase.instance.client;
  bool isLoading = false;
  bool isActive = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedCategory;
  List<String> categories = [];
  String? selectedOffer;
  List<String> offerTypes = [];
  late int bookId = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

      setState(() {
        bookId = args['bookId'] as int;
        _initializeData(bookId);
      });
    });

    fetchCategories();
    fetchOrderType();
  }

  ///
  Future<void> _initializeData(int bookId) async {
    final user = supabase.auth.currentUser;

    try {
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        // showSnackBar(context, 'المستخدم غير موجود');
        return;
      }

      var newTitle = _titleController.text.trim();
      var newdesc = _descriptionController.text.trim();
      var newAuthor = _authorController.text.trim();
      var newCategory = selectedCategory;
      var newCondition = _conditionController.text.trim();
      var newOfferType = selectedOffer;
      var newprice = priceController.text.trim();

      /// Title
      if (newTitle.isEmpty || newTitle == null) {
        final response = await supabase
            .from('books')
            .select('title')
            .eq('id', bookId)
            .single();
        final title = response['title'];

        /// لإظهار الداتا
        if (title != null) {
          _titleController.text = title.toString();
        }

        newTitle = response['title'] as String;
      }

      /// Desc
      if (newdesc.isEmpty || newdesc == null) {
        final response = await supabase
            .from('books')
            .select('description')
            .eq('id', bookId)
            .single();
        final desc = response['description'];

        /// لإظهار الداتا
        if (desc != null) {
          _descriptionController.text = desc.toString();
        }

        newdesc = response['description'] as String;
      }

      /// Author
      if (newAuthor.isEmpty || newAuthor == null) {
        final response = await supabase
            .from('books')
            .select('author')
            .eq('id', bookId)
            .single();
        final author = response['author'];

        /// لإظهار الداتا
        if (author != null) {
          _authorController.text = author.toString();
        }

        newAuthor = response['author'] as String;
      }

      /// Category
      if (newCategory == null) {
        final response = await supabase
            .from('books')
            .select('category')
            .eq('id', bookId)
            .single();
        final category = response['category'];

        /// لإظهار الداتا
        if (category != null) {
          selectedCategory = category.toString();
        }

        newCategory = response['category'] as String;
      }

      /// Condition
      if (newCondition.isEmpty || newCondition == null) {
        final response = await supabase
            .from('books')
            .select('condition')
            .eq('id', bookId)
            .single();
        final condition = response['condition'];

        /// لإظهار الداتا
        if (condition != null) {
          _conditionController.text = condition.toString();
        }

        newCondition = response['condition'] as String;
      }

      /// Offer Type
      if (newOfferType == null) {
        final response = await supabase
            .from('books')
            .select('offer_type')
            .eq('id', bookId)
            .single();
        final offerType = response['offer_type'];

        /// لإظهار الداتا
        if (offerType != null) {
          selectedOffer = offerType.toString();
        }

        newOfferType = response['offer_type'] as String;
      }

      /// Title
      if (newprice.isEmpty || newprice == null) {
        final response = await supabase
            .from('books')
            .select('price')
            .eq('id', bookId)
            .single();
        final price = response['price'];

        /// لإظهار الداتا

        priceController.text = price.toString();

        newprice = response['price'] as String;
      }
      await supabase.from('conversation_participants').update({
        'title_book': newTitle,
      }).eq('book_id', bookId);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  ///
  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select('name');

    setState(() {
      categories = response.map((e) => e['name'] as String).toList();
    });
  }

  ///
  Future<void> fetchOrderType() async {
    final response = await supabase.from('offer_type').select('type');

    setState(() {
      offerTypes = response.map((e) => e['type'] as String).toList();
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

  ///
  Future<void> _uploadImage() async {
    // try {
    setState(() {
      isLoading = true;
    });

    /// رفع الصورة إلى Supabase Storage
    final fileName = 'books/${DateTime.now().toIso8601String()}';
    final fileNameI = 'books/${DateTime.now().toIso8601String()}';
    if (_coverImage != null || _coverImageI != null) {
      await supabase.storage.from('book_covers').upload(
            fileName,
            _coverImage!,
          );
      await supabase.storage.from('book_covers').upload(
            fileNameI,
            _coverImageI!,
          );
      final imageUrl =
          supabase.storage.from('book_covers').getPublicUrl(fileName);
      final imageUrlI =
          supabase.storage.from('book_covers').getPublicUrl(fileNameI);

      /// حفظ رابط الصورة في جدول books
      await supabase.from('books').update({
        'cover_image_url': imageUrl,
      }).eq('id', bookId);

      await supabase.from('books').update({
        'cover_book_url2': imageUrlI,
      }).eq('id', bookId);
      await supabase.from('conversation_participants').update({
        'book_image': imageUrl,
      }).eq('book_id', bookId);
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    // } catch (e) {
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    //   if (mounted) {
    //     showSnackBar(context, e.toString());
    //   }
    // }
  }

  Future getImageTotext(String imagePath) async {
    final textRecognizer = TextRecognizer();
    final recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    final text = recognizedText.text;
    return text;
  }

  late String s = '';
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
    final picker = ImagePicker();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const AppIndicator(),
      child: Scaffold(
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
        body: Padding(
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
                const H(h: 10),
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
                        width: 144,
                        height: 144,
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
                        width: 144,
                        height: 144,
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
                  value: selectedCategory,
                  items: categories
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
                  icon: GestureDetector(
                    onTap: () async {
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        final a = await getImageTotext(image.path);
                        setState(() {
                          s = a.toString();
                        });
                      }
                    },
                    child: const Icon(
                      Icons.copy_all_outlined,
                    ),
                  ),
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
                  value: selectedOffer,
                  items: offerTypes
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
                if (selectedOffer == 'للبيع')
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
                const H(h: 16),
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
                await updateBook(
                  bookId: bookId.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  author: _authorController.text,
                  category: selectedCategory!,
                  condition: _conditionController.text,
                  offerType: selectedOffer!,
                  price: int.tryParse(priceController.text)!,
                  context: context,
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
