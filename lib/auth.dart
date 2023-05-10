import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectjen/hidden_drawer_menu.dart';
import 'package:projectjen/home.dart';
import 'package:projectjen/user_login.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const HiddenDrawer();
          }
          else if(snapshot.hasError){
            return const Center(child: Text('Something Went Wrong :('),);
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else{
            return const UserLogin();
          }
        },
      ),
    );
  }
}
