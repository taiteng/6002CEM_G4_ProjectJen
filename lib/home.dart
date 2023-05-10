import 'package:flutter/material.dart';
import 'package:projectjen/hidden_drawer_menu.dart';
import 'package:projectjen/user_settings.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Home'),
          ],
        ),
      ),
    );
  }
}
