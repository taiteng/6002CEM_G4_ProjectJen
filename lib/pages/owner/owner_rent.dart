import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/pages/owner/owner_inquiry_form.dart';
import 'package:projectjen/widgets/owner_get_rent_property.dart';
import 'package:projectjen/pages/owner/owner_home.dart';
import 'package:projectjen/pages/owner/owner_task.dart';

class OwnerRent extends StatefulWidget {
  const OwnerRent({Key? key}) : super(key: key);

  @override
  State<OwnerRent> createState() => _OwnerRentState();
}

class _OwnerRentState extends State<OwnerRent> {

  List<String> _pIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future getPropertyIDs() async{
    await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').where('SalesType', isEqualTo: 'Rent').get().then(
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
      bottomNavigationBar: Container(
        color: Colors.deepOrange,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: GNav(
            backgroundColor: Colors.deepOrange,
            color: Colors.white,
            activeColor: Colors.white,
            gap: 10,
            tabBackgroundColor: Colors.amber,
            padding: EdgeInsets.all(16),
            selectedIndex: 1,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerHome(),),);
                },
              ),
              GButton(
                icon: Icons.warehouse,
                text: 'Rent',
              ),
              GButton(
                icon: Icons.task,
                text: 'Task',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerTask(),),);
                },
              ),
              GButton(
                icon: Icons.question_answer,
                text: 'Inquiry',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerInquiryForm(),),);
                },
              ),
            ],
          ),
        ),
      ),
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
        title: const Text('Owner Rent'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
          },
        ),
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
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pIDs.length,
                        itemBuilder: (context, index){
                          return GetOwnerRentProperty(propertyID: _pIDs[index],);
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
