import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/hidden_drawer_menu.dart';
import 'package:projectjen/owner_add_property.dart';
import 'package:projectjen/owner_get_property.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({Key? key}) : super(key: key);

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {

  List<String> _pIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future getPropertyIDs() async{
    await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').get().then(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerAddProperty(),),);
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
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
                          return GetOwnerProperty(propertyID: _pIDs[index],);
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
