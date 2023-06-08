import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../widgets/owner_inquiry_form_widget.dart';
import '../hidden_drawer_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_home.dart';
import 'owner_rent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'owner_task.dart';

class OwnerInquiryForm extends StatefulWidget {
  const OwnerInquiryForm({super.key});

  @override
  State<OwnerInquiryForm> createState() => _OwnerInquiryFormState();
}

class _OwnerInquiryFormState extends State<OwnerInquiryForm> {
  final User? user = FirebaseAuth.instance.currentUser;

  final _inquiryIDs = FirebaseFirestore.instance
      .collection("OwnerProperty");


  
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
            padding: const EdgeInsets.all(16),
            selectedIndex: 3,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome(),),);
                },
              ),
              GButton(
                icon: Icons.warehouse,
                text: 'Rent',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerRent(),),);
                },
              ),
              GButton(
                icon: Icons.task,
                text: 'Task',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerTask(),),);
                },
              ),
              const GButton(
                icon: Icons.question_answer,
                text: 'Inquiry',
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
        title: const Text('Owner Inquiry Form Lists'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: _inquiryIDs.doc(user?.uid.toString())
                    .collection("InquiryFormProperty")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Text("loading");
                  } else{
                    return ListView(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                        return OwnerInquiryFormWidget(
                          inquiryID: data['pID'],
                          date: data['Date'],
                          name: data['Name'],
                          email: data['Email'],
                          phone: data['Phone'],
                          comments: data['Comments'],
                        );
                      }).toList(),
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
