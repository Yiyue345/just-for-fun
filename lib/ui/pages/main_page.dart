import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/edit_article_page.dart';
import 'package:go_deeper/ui/pages/article_pages/user_articles_page.dart';
import 'package:go_deeper/ui/pages/other_user_page/controller.dart';
import 'package:go_deeper/ui/pages/settings_page/settings_page.dart';
import 'package:go_deeper/ui/pages/suggestion_page.dart';
import 'package:go_deeper/ui/pages/test_page.dart';
import 'package:go_deeper/ui/pages/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;



  final _pages = [
    SuggestionPage(),
    UserPage()
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    Get.put(UserController());
    Get.put(FeedItemController());
    Get.put(SettingsController());
    Get.put(UserFeedItemsController());
    Get.put(OtherUsersController());
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context)!.user),
    ];

    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        actions: _selectedIndex == 1
            ? [
              Obx(() => userController.isLoggedIn.value
                  ? IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.notifications)
              )
                  : SizedBox.shrink()
              ),
              IconButton(onPressed: () {
                Get.to(() => SettingsPage());
              },
                  icon: Icon(Icons.settings)
              ),

            Obx(
                    () => userController.isLoggedIn.value
                        ? IconButton(
                        onPressed: () {
                          showSignOutDialog();
                          },
                        icon: Icon(
                            Icons.logout,
                          color: Colors.red,
                        )
                    )
                        : IconButton(
                        onPressed: () {
                          showSignInDialog();
                          },
                        icon: Icon(
                            Icons.login,
                          color: Colors.blue,
                        )
                    )
            )
        ]
            : null,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      floatingActionButton: Obx(() {
        if (userController.isLoggedIn.value && _selectedIndex == 0) {
          return FloatingActionButton(onPressed: () {
            Get.to(() => EditArticlePage());
          },
            shape: CircleBorder(),
            child: Icon(Icons.add),
          );
        }
        else {
          return SizedBox.shrink();
        }
      })
      ,
      bottomNavigationBar: BottomNavigationBar(
          items: bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}