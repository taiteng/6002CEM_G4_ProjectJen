import 'package:flutter/material.dart';
import 'package:projectjen/model/user_rent_model.dart';
import 'package:projectjen/pages/owner/owner_add_user.dart';
import 'package:projectjen/pages/owner/owner_rent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/user_rent_widget.dart';

class OwnerRentAssign extends StatefulWidget {

  final String propertyID, propertyName;

  const OwnerRentAssign({
    Key? key,
    required this.propertyID,
    required this.propertyName,
  }) : super(key: key);

  @override
  State<OwnerRentAssign> createState() => _OwnerRentAssignState();
}

class _OwnerRentAssignState extends State<OwnerRentAssign> {

  List<UserRentModel> userList = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<UserRentModel>> fetchRentUsers() async {
    List<UserRentModel> userList = [];

    final User? user = FirebaseAuth.instance.currentUser;

    final rentUserSnapshot = await FirebaseFirestore.instance
        .collection('OwnerProperty')
        .doc(user?.uid.toString())
        .collection('RentUserID')
        .where('pID', isEqualTo: widget.propertyID.toString())
        .get();

    for (final rentUser in rentUserSnapshot.docs) {
      if (rentUser.exists) {
        final usersSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('UID', isEqualTo: rentUser.reference.id)
            .get();

        for (final userDoc in usersSnapshot.docs) {
          if (userDoc.exists) {
            String profileURL = userDoc['ProfilePic'];
            String username = userDoc['Username'];
            String uid = userDoc['UID'];

            UserRentModel user = UserRentModel(
              profileURL: profileURL,
              username: username,
              UID: uid,
            );

            userList.add(user);
          } else {
            print("Ntg to see here");
          }
        }
      } else {
        print("0");
      }
    }

    return userList;
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
        title: Text('Owner Rent Assign: ${widget.propertyName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerRent(),),);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add,),
            color: Colors.white,
            tooltip: 'Add Icon',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerAddUser(propertyID: widget.propertyID, propertyName: widget.propertyName,),),);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: fetchRentUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.hasData){
                        userList = snapshot.data!;
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: userList.length,
                        itemBuilder: (context, index){
                          return UserRentWidget(userRentModel: userList[index], propertyID: widget.propertyID, propertyName: widget.propertyName);
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
