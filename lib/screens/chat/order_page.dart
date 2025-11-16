import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/cubit/messages/fetch_user_conversations_cubit.dart';
import 'package:biblio/screens/chat/incoming_requests.dart';
import 'package:biblio/screens/chat/submitted_requests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    fetchDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchDate() {
    context
      ..read<FetchUserConversationsCubit>().fetchSendConversations()
      ..read<FetchUserConversationsCubit>().fetchReceiverConversations();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 300),
      length: 2, // عدد العلامات التبويب

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.sp,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(16.sp),
            title: TabBar(
              automaticIndicatorColorAdjustment: false,
              dividerHeight: 0,
              indicatorColor: kTextColor,
              labelColor: Colors.white,
              unselectedLabelColor: kTextColor,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w500,
              ),
              indicatorAnimation: TabIndicatorAnimation.elastic,
              onTap: (index) {
                setState(() {});
              },
              indicator: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.fill,
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Incoming requests'.tr(),
                  ),
                ),
                Tab(
                  child: Text(
                    'Submitted requests'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            IncomingRequests(),
            SubmittedRequests(),
          ],
        ),
      ),
    );
  }
}
