import 'package:flutter/material.dart';
import 'package:projectjen/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_)=> const Settings(),),),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
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
