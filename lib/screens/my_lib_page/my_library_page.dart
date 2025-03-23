import 'package:biblio/screens/my_lib_page/added_library.dart';
import 'package:biblio/screens/my_lib_page/empty_library.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({super.key});

  @override
  State<MyLibraryPage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabase
          .from('books')
          // ignore: avoid_redundant_argument_values
          .select('*')
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          .order('created_at', ascending: false);

      setState(() {
        books = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      // showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kMainColor,
        toolbarHeight: 80.sp,
        centerTitle: true,

        /// Title
        title: Text(
          'Your library'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.sp,
          ),
        ),

        /// Leading
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // إزالة جميع الصفحات
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const AppIndicator()
          : books.isEmpty
              ? const EmptyLibrary()
              : AddedLibrary(books: books),
    );
  }
}
