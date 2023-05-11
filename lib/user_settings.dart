import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:projectjen/owner_home.dart';
import 'package:projectjen/user_function.dart';
import 'package:projectjen/user_recently_viewed.dart';
import 'package:provider/provider.dart';
import 'package:projectjen/google_sign_in.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference _user = FirebaseFirestore.instance.collection('Users');

  Future<String> getLoginMethod() async {
    final String? uid = user?.uid.toString();
    String loginmethod = await FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) => value.get('LoginMethod'));

    return loginmethod.toString();
  }

  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  void signOutFacebook() async{

  }

  void signOutGoogle() async{
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    await provider.googleLogout();
  }

  bool roleSwitchController = false;

  void changeRole(String e, String p, String u, String pp, String lm) async{
    final String? uid = user?.uid.toString();
    String userRole = await FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) => value.get('Role'));

    if(userRole == 'Owner'){
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'Email' : e.toString(),
        'Phone' : p.toString(),
        'Username' : u.toString(),
        'ProfilePic' : pp.toString(),
        'LoginMethod' : lm.toString(),
        'UID' : FirebaseAuth.instance.currentUser!.uid,
        'Role': 'Renter',
      });
    }
    else{
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'Email' : e.toString(),
        'Phone' : p.toString(),
        'Username' : u.toString(),
        'ProfilePic' : pp.toString(),
        'LoginMethod' : lm.toString(),
        'UID' : FirebaseAuth.instance.currentUser!.uid,
        'Role': 'Owner',
      });
    }

    setState(() {

    });
  }

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
                      title: Text(data['UID']),
                      trailing: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: data['UID'])).then((_){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User ID has been copied to clipboard")));
                          });
                        },
                      ),
                    ),
                    const Divider(),
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
                    const Divider(),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRecentlyViewed(),),),
                      },
                      child: ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: Text('Recently Viewed'),
                      ),
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
                      title: Text(data['Role']),
                      trailing: Switch(
                          value: (data['Role'] == 'Owner')?roleSwitchController = true: roleSwitchController = false,
                          activeColor: Colors.deepOrangeAccent,
                          onChanged: (val) {
                            setState(() {
                              changeRole(data['Email'], data['Phone'], data['Username'], data['ProfilePic'], data['LoginMethod']);
                            });
                          }),
                    ),
                    const Divider(),
                    if(data['Role'] == 'Owner')
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome(),),),
                        },
                        child: ListTile(
                          leading: Icon(Icons.people),
                          title: Text('Click to Access Owner\'s Page'),
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
                    const Divider(),
                    GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Profile'),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () async {
                        if(data['LoginMethod'] == 'Email'){
                          signOut();
                        }
                        else if (data['LoginMethod'] == 'Google'){
                          signOutGoogle();
                        }
                        else if(data['LoginMethod'] == 'Google'){
                          signOutFacebook();
                        }
                      },
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
