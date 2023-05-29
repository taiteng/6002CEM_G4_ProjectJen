import 'package:flutter/material.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'user_login.dart';
import '../const/login_register_bg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRegister extends StatefulWidget {

  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  String? dropdownValue;

  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  void signUp() async{
    try{
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'Email' : emailController.text,
          'Phone' : phoneNumberController.text,
          'Username' : usernameController.text,
          'ProfilePic' : 'https://media.istockphoto.com/id/1316420668/vector/user-icon-human-person-symbol-social-profile-icon-avatar-login-sign-web-user-symbol.jpg?s=612x612&w=0&k=20&c=AhqW2ssX8EeI2IYFm6-ASQ7rfeBWfrFFV4E87SaFhJE=',
          'Role' : dropdownValue.toString(),
          'LoginMethod' : 'Email',
          'UID' : FirebaseAuth.instance.currentUser!.uid,
        });

        await FirebaseFirestore.instance.collection('OwnerProperty').doc(FirebaseAuth.instance.currentUser!.uid).collection('OwnerPropertyIDs').doc('j7HIy8dCj9mlYsQfvzyr').set({
          'pID' : 'j7HIy8dCj9mlYsQfvzyr',
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HiddenDrawer(pageNum: 0,)));
        });
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.pinkAccent,
              title: Text('Password Does Not Match'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pinkAccent,
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "REGISTER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFe7494b),
                      fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: 5),

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

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.phone_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              labelText: "Phone Number"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.account_circle_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                              labelText: "Username"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

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

              const SizedBox(height: 5),

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
                          controller: confirmPasswordController,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              labelText: "Confirm Password"
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                          value: dropdownValue,
                          isExpanded: true,
                          hint: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Choose your role'),
                          ),
                          items: ['Renter', 'Owner'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: signUp,
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
                      "SIGN UP",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()))
                  },
                  child: const Text(
                    "Already Have an Account? Sign in",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFe7494b),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}