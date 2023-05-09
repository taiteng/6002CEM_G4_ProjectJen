import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectjen/home.dart';
import 'package:projectjen/user_forgot_password.dart';
import 'package:projectjen/user_register.dart';
import 'package:projectjen/login_register_bg.dart';

class UserLogin extends StatefulWidget {

   UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Home()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

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
      body: Background(
        child: SingleChildScrollView(
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
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: "Email"
                          ),
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
                    SizedBox(
                      width: 300,
                      child: Container(
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
                              Color.fromARGB(255, 255, 177, 41)
                            ]
                        )
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
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.facebook_rounded, size: 45, color: Colors.blueAccent,),
                    ),
                    const SizedBox(height: 20, width: 20,),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.email_rounded, size: 45, color: Colors.deepOrange,),
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