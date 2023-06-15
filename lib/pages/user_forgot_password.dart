import 'package:flutter/material.dart';
import 'package:projectjen/const/login_register_bg.dart';
import 'package:projectjen/pages/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserForgotPassword extends StatefulWidget {
  const UserForgotPassword({Key? key}) : super(key: key);

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.pinkAccent,
            title: Text('Reset Link Sent'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text('User Not Found'),
          );
        },
      );
    }
  }

  /*
  The first part before @ checks for the local part of the email address:
  ([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*) matches one or more characters that are not <, >, (, ), [, \, ., ,, ;, :, whitespace, @, or ". This ensures that there are no invalid characters in the local part.
  (\.[^<>()[\]\\.,;:\s@\"]+)* allows for periods followed by one or more characters that are not the same set of invalid characters. This allows for the presence of periods in the local part but ensures they are followed by valid characters.
  (\".+\") allows for the local part to be enclosed in double quotes. This is an alternative format for the local part that allows certain special characters. For example, an email like "john.doe"@example.com is valid.
  The second part after @ checks for the domain part of the email address:
  (\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\]) matches an IP address enclosed in square brackets. This allows for email addresses in the format [192.168.0.1].
  (([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}) matches the domain name, which consists of one or more groups of alphanumeric characters or hyphens followed by a period. The last group must be two or more alphabetical characters. This ensures that the domain name is valid, such as example.com.
  */

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "RESET PASSWORD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFe7494b),
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Enter your email and we will send you a password reset link.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFe7494b),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

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
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              else{
                                bool emailValid = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(value);

                                if (emailValid) {
                                  return null;
                                } else {
                                  return "Please provide a valid email address";
                                }
                              }
                            },
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

                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()))
                    },
                    child: const Text(
                      "Go back to Login?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Loading')),
                        );

                        resetPassword();
                      }
                    },
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
                        "RESET",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
