import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/user_auth.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/ui/pages/settings_page/settings_page.dart';
import 'package:go_deeper/ui/pages/test_page.dart';
import 'package:go_deeper/ui/pages/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
  ];

  final _pages = [
    Center(
      child: ElevatedButton(
          onPressed: () {
            Get.to(() => TestPage());
          },
          child: Text('Go to Test Page')
      ),
    ),
    UserPage()
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    Get.put(UserController());
  }

  @override
  Widget build(BuildContext context) {

    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        actions: _selectedIndex == 1
            ? [
              IconButton(onPressed: () {
                Get.to(() => SettingsPage());
              },
                  icon: Icon(Icons.settings)
              ),

            Obx(
                    () => userController.isLoggedIn.value
                        ? IconButton(
                        onPressed: () {
                          showSignOutDialog(context);
                          },
                        icon: Icon(
                            Icons.logout,
                          color: Colors.red,
                        )
                    )
                        : IconButton(
                        onPressed: () {
                          showSignInDialog(context);
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(onPressed: () {
          
          },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      )
          : null
      ,
      bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavItems,
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