// الأسئلة الشائعة (FAQ) لتطبيق Biblio

import 'package:biblio/utils/components/leading_icon.dart';
import 'package:biblio/utils/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqList = <Map<String, String>>[
      {
        'question': 'ما هو تطبيق Booklink؟',
        'answer':
            'Booklink هو تطبيق يهدف إلى تسهيل تبادل الكتب بين المستخدمين. يمكنك عرض الكتب التي ترغب في تبادلها أو إعارتها، أو بيعها، أو التبرع بها، والبحث عن كتب تناسب اهتماماتك.',
      },
      {
        'question': 'كيف يمكنني إنشاء حساب؟',
        'answer':
            'يمكنك إنشاء حساب بسهولة باستخدام بريدك الإلكتروني وكلمة المرور، أو التسجيل باستخدام حساب Google الخاص بك.',
      },
      {
        'question': 'كيف أضيف كتابًا إلى قائمة التبادل الخاصة بي؟',
        'answer':
            '1. افتح التطبيق واضغط على زر "إضافة كتاب".\n2. أضف صورة غلاف الكتاب.\n3. أدخل تفاصيل الكتاب (العنوان، المؤلف، الحالة، وصف قصير).\n4. اضغط على "حفظ"، وسيتم عرض الكتاب في قائمتك.',
      },
      {
        'question': 'كيف أبحث عن كتب متاحة للتبادل؟',
        'answer':
            'استخدم شريط البحث في الصفحة الرئيسية للبحث عن كتاب أو مؤلف معين، أو استعرض المكتبة العامة لتصفح الكتب حسب الفئات.',
      },
      {
        'question': 'كيف أبدأ عملية تبادل الكتب؟',
        'answer':
            '1. عند العثور على كتاب يناسبك، اضغط على الكتاب لعرض تفاصيله.\n2. اختر خيار "طلب الكتاب" وأرسل رسالة لصاحب الكتاب.\n3. سيتم إرسال إشعار إلى مالك الكتاب، ويمكنكما الاتفاق على شروط التبادل عبر الرسائل.',
      },
      {
        'question': 'هل التبادل يتم داخل التطبيق فقط؟',
        'answer':
            'نعم، يمكنك بدء عملية التبادل داخل التطبيق، ولكن تفاصيل الشحن أو التسليم الشخصي تعتمد على الاتفاق بينك وبين المستخدم الآخر.',
      },
      {
        'question': 'هل يوجد رسوم لاستخدام التطبيق؟',
        'answer':
            'التطبيق مجاني للاستخدام الأساسي. قد تكون هناك رسوم رمزية إذا اخترت خدمات إضافية مثل التوصيل أو الاشتراك المميز.',
      },
      {
        'question': 'كيف أضمن أمان التبادل؟',
        'answer':
            'سيتم إضافة ميزة التقييمات والمراجعات للتحقق من موثوقية المستخدم. لا تشارك بياناتك الشخصية إلا عند الضرورة، والتزم بشروط التبادل المتفق عليها داخل التطبيق.',
      },
      {
        'question': 'ماذا أفعل إذا واجهت مشكلة مع مستخدم آخر؟',
        'answer':
            'إذا واجهت أي مشكلة، يمكنك الإبلاغ عن المستخدم من خلال ملفه الشخصي، أو التواصل مع فريق الدعم الفني عبر المزيد > الدعم الفني.',
      },
      {
        'question': 'هل يمكنني حذف حسابي؟',
        'answer':
            'نعم، يمكنك حذف حسابك في أي وقت من خلال المزيد > إدارة الحساب، ثم الضغط على "حذف الحساب". سيتم حذف جميع بياناتك بعد تأكيد العملية.',
      },
      {
        'question': 'هل يمكنني تعديل بيانات كتاب قمت بإضافته؟',
        'answer':
            'نعم، يمكنك تعديل أي كتاب مضاف من خلال الانتقال إلى "كتبي"، اختيار الكتاب، ثم الضغط على أيقونة "تعديل".',
      },
      {
        'question': 'كيف أتواصل مع فريق الدعم الفني؟',
        'answer':
            'يمكنك التواصل معنا من خلال البريد الإلكتروني: booklink.app@gmail.com، أو استخدام ميزة الدردشة داخل التطبيق في قسم "الدعم الفني".',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const LeadingIcon(),
        title: Text(
          'الأسئلة الشائعة',
          style: TextStyle(
            color: kTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.sp,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 16.sp,
        ),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            collapsedIconColor: kMainColor,
            iconColor: kMainColor,
            title: Text(
              faqList[index]['question']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kMainColor,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.sp,
                  horizontal: 16.sp,
                ),
                child: Text(
                  faqList[index]['answer']!,
                  style: const TextStyle(
                    color: kTextColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
