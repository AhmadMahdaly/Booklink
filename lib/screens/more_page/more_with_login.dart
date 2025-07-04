import 'package:biblio/screens/chat/help_chat/help_chat_screen.dart';
import 'package:biblio/screens/more_page/widgets/acount_manegment_screen.dart';
import 'package:biblio/screens/more_page/widgets/category_for_more.dart';
import 'package:biblio/screens/more_page/widgets/faq_page.dart';
import 'package:biblio/screens/more_page/widgets/personal_card.dart';
import 'package:biblio/screens/more_page/widgets/sign_out_button.dart';
import 'package:biblio/services/launch_url.dart';
import 'package:biblio/utils/components/height.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MoreWithLogin extends StatelessWidget {
  const MoreWithLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          const PersonalCard(),
          const H(h: 12),
          CategoryForMore(
            text: 'Account Management'.tr(),
            icon: Icons.mode_edit_outline_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AcountManegmentScreen();
                  },
                ),
              );
            },
          ),
          const H(h: 12),
          CategoryForMore(
            text: 'FAQ'.tr(),
            icon: Icons.help_outline_sharp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const FAQPage();
                  },
                ),
              );
            },
          ),
          const H(h: 12),
          CategoryForMore(
            text: 'TermsAndConditions'.tr(),
            icon: Icons.text_snippet_outlined,
            onTap: () => launchURL(
              'https://booklink-app.blogspot.com/2025/02/blog-post.html',
            ),
          ),
          const H(h: 12),
          CategoryForMore(
            text: 'policyPrivacy'.tr(),
            icon: Icons.privacy_tip_outlined,
            onTap: () => launchURL(
              'https://booklink-app.blogspot.com/2025/07/blog-post.html',
            ),
          ),
          const H(h: 12),
          CategoryForMore(
            text: 'Technical support'.tr(),
            icon: Icons.headset_mic_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const HelpChatScreen();
                  },
                ),
              );
            },
          ),
          const H(h: 12),
          const SignOutButton(),
        ],
      ),
    );
  }
}
