import 'package:flutter/material.dart';

class UserRecentlyViewed extends StatefulWidget {
  const UserRecentlyViewed({Key? key}) : super(key: key);

  @override
  State<UserRecentlyViewed> createState() => _UserRecentlyViewedState();
}

class _UserRecentlyViewedState extends State<UserRecentlyViewed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Recently Viewed'),
          ],
        ),
      ),
    );
  }
}
