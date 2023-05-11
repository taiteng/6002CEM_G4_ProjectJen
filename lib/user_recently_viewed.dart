import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/user_get_recently_viewed.dart';

class UserRecentlyViewed extends StatefulWidget {
  const UserRecentlyViewed({Key? key}) : super(key: key);

  @override
  State<UserRecentlyViewed> createState() => _UserRecentlyViewedState();
}

class _UserRecentlyViewedState extends State<UserRecentlyViewed> {

  List<String> _pIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  //https://firebase.flutter.dev/docs/firestore/usage/
  Future getPropertyIDs() async{
    await FirebaseFirestore.instance.collection('RecentlyViewed').doc(user?.uid.toString()).collection('PropertyIDs').get().then(
          (snapshot) => snapshot.docs.forEach((properties) {
            if (properties.exists) {
              _pIDs.add(properties.reference.id);
            } else {
              print("Ntg to see here");
            }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getPropertyIDs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: _pIDs.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.home),
                              tileColor: Colors.yellowAccent,
                              title: GetRecentlyViewed(propertyID: _pIDs[index],),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Text("loading");
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
