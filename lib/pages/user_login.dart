import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/data/google_sign_in.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'package:projectjen/pages/user_forgot_password.dart';
import 'package:projectjen/pages/user_register.dart';
import 'package:projectjen/const/login_register_bg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Login',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: UserLoginPage(),
    );
  }
}

class UserLoginPage extends StatefulWidget {

  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<UserCredential> signInWithFacebook() async {
    //App ID: 786474549715950
    //App Secret: f70971eee1554b5b50efed88c3fe73e7
    //Callback URL: https://projectjen-624d5.firebaseapp.com/__/auth/handler
    final LoginResult? loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult!.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void signInWithTwitter() async {
    //API Key: fjd995xhFyzcCjOFtxTEmSEVr
    //API Key Secret: 6xV2yo1KaU4svMK58Wfsy7nwFDzHqI7B0z598Y3H55BAM9H4Qw
    //Client ID: OVVTOXN0a1dMYzJDOWRLOG40SDE6MTpjaQ
    //Client Secret: aR64QO7DDp230ZxAn0bDHMF_PBfkUqiWwA80pRWQGsYo-B33dk
    //Callback URL: https://projectjen-624d5.firebaseapp.com/__/auth/handler

    try{
      final twitterLogin = TwitterLogin(
          apiKey: 'fjd995xhFyzcCjOFtxTEmSEVr',
          apiSecretKey: '6xV2yo1KaU4svMK58Wfsy7nwFDzHqI7B0z598Y3H55BAM9H4Qw',
          redirectURI: 'flutter-twitter-login://'
      );

      final authResult = await twitterLogin.login();

      if(authResult.status == TwitterLoginStatus.loggedIn){
        final twitterCredentials = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        await FirebaseAuth.instance.signInWithCredential(twitterCredentials);

        final User? user = FirebaseAuth.instance.currentUser;

        final userDetails = authResult.user;

        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'Email' : userDetails!.email,
          'Phone' : '0123456789',
          'Username' : userDetails!.screenName,
          'ProfilePic' : userDetails!.thumbnailImage,
          'Role' : 'Renter',
          'LoginMethod' : 'Twitter',
          'UID' : FirebaseAuth.instance.currentUser!.uid,
        });
      }
      else{
        print('Smtg went wrong');
      }
    } catch (e){
      print(e);
    }
  }

  void signIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HiddenDrawer(pageNum: 0,)));
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.pinkAccent,
              title: Text('Incorrect Email'),
            );
          },
        );
      }
      else if(e.code == 'wrong-password'){
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.pinkAccent,
              title: Text('Incorrect Password'),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFe7494b),
                      fontSize: 36,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.email_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    Container(
                      width: 300,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: "Email"
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.password_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    Container(
                      width: 300,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: passwordController,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                            labelText: "Password"
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserForgotPassword()))
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFe7494b),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegister()))
                  },
                  child: const Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFe7494b),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        signInWithFacebook();
                      },
                      padding: EdgeInsets.zero,
                      icon: Image.asset('assets/images/facebook.png'),
                      iconSize: 45,
                    ),
                    const SizedBox(height: 20, width: 20,),
                    IconButton(
                      onPressed: () async {
                        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                        await provider.googleLogin();
                      },
                      padding: EdgeInsets.zero,
                      icon: Image.asset('assets/images/google-plus.png'),
                      iconSize: 45,
                    ),
                    const SizedBox(height: 20, width: 20,),
                    IconButton(
                      onPressed: () async {
                        signInWithTwitter();
                      },
                      padding: EdgeInsets.zero,
                      icon: Image.asset('assets/images/twitter.png'),
                      iconSize: 45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}