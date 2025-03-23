import 'package:biblio/screens/category_page/category_page.dart';
import 'package:biblio/screens/category_page/widgets/category_item.dart';
import 'package:biblio/utils/components/app_indicator.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategorySeeAll extends StatefulWidget {
  const CategorySeeAll({super.key});

  @override
  State<CategorySeeAll> createState() => _CategorySeeAllState();
}

class _CategorySeeAllState extends State<CategorySeeAll> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await supabase
          .from('categories')
          // ignore: avoid_redundant_argument_values
          .select('*')
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          books = List<Map<String, dynamic>>.from(response);
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // showSnackBar(context, 'هناك خطأ! $e.');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.sp,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Book categories'.tr(),
          style: TextStyle(
            color: kTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.sp,
          ),
        ),

        /// Leading
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22.sp,
          ),
        ),
      ),
      body: isLoading
          ? const AppIndicator()
          : GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 16.sp,
                vertical: 16.sp,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 6.sp,
                mainAxisSpacing: 20.sp,
              ),
              itemBuilder: (context, index) {
                final book = books[index];
                return CategoryItem(
                  icon: book['icon'].toString(),
                  title: book['name'].toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryPage(category: book['name'].toString()),
                      ),
                    );
                  },
                );
              },
              itemCount: books.length,
            ),
    );
  }
}
