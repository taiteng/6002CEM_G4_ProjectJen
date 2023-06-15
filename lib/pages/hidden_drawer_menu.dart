import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:projectjen/pages/home.dart';
import 'package:projectjen/pages/news.dart';
import 'package:projectjen/pages/user_settings.dart';
import 'package:projectjen/pages/user_task.dart';

import 'favorite.dart';

class HiddenDrawer extends StatefulWidget {

  final int pageNum;

  const HiddenDrawer({Key? key, required this.pageNum,}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Home',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepPurpleAccent,
        ),
        const Home(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Favourite',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepPurpleAccent,
        ),
        const Favourite(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepPurpleAccent,
        ),
        const UserSettings(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Task',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepPurpleAccent,
        ),
        const UserTask(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'News',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepPurpleAccent,
        ),
        const NewsPage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.orangeAccent,
      screens: _pages,
      initPositionSelected: widget.pageNum,
      slidePercent: 40,
      contentCornerRadius: 25,
      isTitleCentered: true,
    );
  }
}
