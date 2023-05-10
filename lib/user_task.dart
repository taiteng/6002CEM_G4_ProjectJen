import 'package:flutter/material.dart';

class UserTask extends StatefulWidget {
  const UserTask({Key? key}) : super(key: key);

  @override
  State<UserTask> createState() => _UserTaskState();
}

class _UserTaskState extends State<UserTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User Task'),
      ),
    );
  }
}
