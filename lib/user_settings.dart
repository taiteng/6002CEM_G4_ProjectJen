import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/owner_home.dart';
import 'package:projectjen/user_login.dart';
import 'package:projectjen/user_function.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

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
    String loginmethod = await FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) => value.get('LoginMethod'));

    return loginmethod.toString();
  }

  void signOut() async{
    if(getLoginMethod().toString() == 'Email'){
      await FirebaseAuth.instance.signOut();
    }
    else if (getLoginMethod().toString() == 'Google'){
      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.googleLogin();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UserLogin()));
  }

  bool roleSwitchController = false;

  TextStyle headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red);

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );
  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: FutureBuilder<DocumentSnapshot>(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Profile",
                          style: headingStyle,
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data['ProfilePic']),
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(data['Email']),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(data['Phone']),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(data['Username']),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Role", style: headingStyle),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("Role"),
                      trailing: Switch(
                          value: roleSwitchController,
                          activeColor: Colors.deepOrangeAccent,
                          onChanged: (val) {
                            setState(() {
                              roleSwitchController = val;
                            });
                          }),
                    ),
                    const Divider(),
                    if(data['Role'] == 'Owner')
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome()))
                        },
                        child: ListTile(
                          leading: Icon(Icons.people),
                          title: Text('Access to Owners\'s Home Page Here'),
                        ),
                      ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Account", style: headingStyle),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.edit_notifications),
                        title: Text('Edit Notifications'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Profile'),
                      ),
                    ),
                    GestureDetector(
                      onTap: signOut,
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Sign Out'),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Misc", style: headingStyle),
                      ],
                    ),
                    const ListTile(
                      leading: Icon(Icons.file_open_outlined),
                      title: Text("Terms of Service"),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.file_copy_outlined),
                      title: Text("Open Source and Licences"),
                    ),
                  ],
                );
              }
              else {
                return const Text("loading");
              }
            },
          ),
        ),
      ),
    );
  }
}
