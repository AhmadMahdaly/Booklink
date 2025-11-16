import 'package:biblio/core/animations/animate_do.dart';
import 'package:biblio/core/constants/colors_constants.dart';
import 'package:biblio/core/services/error_message.dart';
import 'package:biblio/core/shared_controllers/app_states.dart';
import 'package:biblio/features/books/presentation/views/add_book.dart';
import 'package:biblio/features/chat/presentation/controllers/create_conversation_cubit.dart';
import 'package:biblio/features/chat/presentation/controllers/fetch_unread_message_cubit.dart';
import 'package:biblio/features/chat/presentation/views/order_page.dart';
import 'package:biblio/features/favorites_page/views/favorites_page.dart';
import 'package:biblio/features/home_page/home_page_screen.dart';
import 'package:biblio/features/more_page/more_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});
  static String id = 'NavigationBarApp';

  @override
  State<NavigationBarApp> createState() => NavigationBarAppState();
}

class NavigationBarAppState extends State<NavigationBarApp> {
  int _currentIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const OrderPage(),
    const SizedBox(),
    const FavoritesPage(),
    const MorePage(),
  ];
  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  Future<void> fetchDate() async {
    await context.read<FetchUnreadMessageCubit>().fetchUnreadMessages(
          otherId:
              context.read<CreateConversationCubit>().otherUserId.toString(),
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool?> showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kLightBlue,
            title: Text(
              'Confirm'.tr(),
              style: TextStyle(
                color: kMainColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'ExitMsg'.tr(),
              style: TextStyle(
                color: kMainColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(
                  false,
                ),
                child: Text(
                  'No'.tr(),
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(
                  true,
                ),
                child: Text(
                  'Yes'.tr(),
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; // Return false if the dialog is dismissed.
  }

  @override
  Widget build(BuildContext context) {
    context.read<FetchUnreadMessageCubit>().fetchUnreadMessages(
          otherId:
              context.read<CreateConversationCubit>().otherUserId.toString(),
        );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitConfirmation(context);
        return shouldExit!;
      },
      child: Scaffold(
        body: pages.elementAt(_currentIndex),
        bottomNavigationBar: BlocConsumer<FetchUnreadMessageCubit, AppStates>(
          listener: (context, state) {
            if (state is AppErrorState) {
              errorMessage(state.message, context);
            }
          },
          builder: (context, state) {
            return CustomFadeInUp(
              duration: 500,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  BottomNavigationBar(
                    landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
                    backgroundColor: Colors.white,
                    currentIndex: _currentIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: kMainColor,
                    unselectedItemColor: kTextColor,
                    selectedLabelStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: kTextColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    elevation: 50,
                    iconSize: 24.sp,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      /// Explore button
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/svg/explore.svg',
                          width: _currentIndex == 0 ? 28.sp : 24.sp,
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 0 ? kMainColor : kTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: 'Explore'.tr(),
                      ),

                      /// Order button
                      BottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/Chat.svg',
                              width: _currentIndex == 1 ? 28.sp : 24.sp,
                              colorFilter: ColorFilter.mode(
                                _currentIndex == 1 ? kMainColor : kTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            if (context
                                    .read<FetchUnreadMessageCubit>()
                                    .notificationCount >
                                0)
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 10.sp,
                                    minHeight: 10.sp,
                                  ),
                                  child: Text(
                                    '${context.read<FetchUnreadMessageCubit>().notificationCount}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        label: 'Requests'.tr(),
                      ),

                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          radius: 15.sp,
                          backgroundColor: Colors.white,
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/svg/ph_books.svg',
                          width: _currentIndex == 3 ? 28.sp : 24.sp,
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 3 ? kMainColor : kTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: 'MyList'.tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/svg/more.svg',
                          width: _currentIndex == 4 ? 28.sp : 24.sp,
                          colorFilter: ColorFilter.mode(
                            _currentIndex == 4 ? kMainColor : kTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: 'More'.tr(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -16, // تحريك العنصر للخروج من الإطار
                    left: MediaQuery.of(context).size.width / 2 -
                        32, // منتصف الشاشة
                    child: InkWell(
                      // تحديث المؤشر عند النقر
                      borderRadius: BorderRadius.circular(320.sp),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBook(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 32.sp,
                        backgroundColor: kMainColor,
                        child: SvgPicture.asset(
                          'assets/svg/add.svg',
                          width: 32.sp,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
