import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'package:projectjen/widgets/user_get_recently_viewed.dart';
import 'package:intl/intl.dart';

class UserRecentlyViewed extends StatefulWidget {
  const UserRecentlyViewed({Key? key}) : super(key: key);

  @override
  State<UserRecentlyViewed> createState() => _UserRecentlyViewedState();
}

class _UserRecentlyViewedState extends State<UserRecentlyViewed> {

  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  List<String> _pIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  //https://firebase.flutter.dev/docs/firestore/usage/
  Future getPropertyIDs() async{
    await FirebaseFirestore.instance.collection('RecentlyViewed').doc(user?.uid.toString()).collection('PropertyIDs').where('Date', isEqualTo: currentDate).get().then(
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
      appBar: AppBar(
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        title: const Text('Recently Viewed'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
          },
        ),
      ),
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
                          return GetRecentlyViewed(propertyID: _pIDs[index],);
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
