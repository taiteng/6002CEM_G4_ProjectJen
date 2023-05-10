import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/user_login.dart';
import 'package:projectjen/user_function.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference _user = FirebaseFirestore.instance.collection(
      'Users');

  Future<String> getUsername() async {
    final String? uid = user?.uid.toString();
    String Username = await FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) => value.get('Username'));

    return Username.toString();
  }

  Future<String> getLoginMethod() async {
    final String? uid = user?.uid.toString();
    String Username = await FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) => value.get('LoginMethod'));

    return Username.toString();
  }

  void signOut() async{
    if(getLoginMethod().toString() == 'Email'){
      await FirebaseAuth.instance.signOut();
    }
    else if (getLoginMethod().toString() == 'Google'){
      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.googleLogin();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => UserLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings'),
            const SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: _user.doc(getUserInfo().getUID().toString()).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                else if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Username does not exist");
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(data['ProfilePic']),
                      ),
                      Text(data['Email'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(data['Phone'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(data['Username'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(data['Role'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(data['ProfilePic'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return const Text("loading");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
