import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner/owner_rent_assign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerAddUser extends StatefulWidget {

  final String propertyID, propertyName;

  const OwnerAddUser({
    Key? key,
    required this.propertyID,
    required this.propertyName,
  }) : super(key: key);

  @override
  State<OwnerAddUser> createState() => _OwnerAddUserState();
}

class _OwnerAddUserState extends State<OwnerAddUser> {

  final _formKey = GlobalKey<FormState>();

  final User? user = FirebaseAuth.instance.currentUser;

  final uidController = TextEditingController();

  addUser() async{
    try{
      await FirebaseFirestore.instance.collection('Users').where('UID', isEqualTo: uidController.text.toString()).get().then(
            (snapshot) => snapshot.docs.forEach((u) async {
          if (u.exists) {
            await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('RentUserID').doc(uidController.text.toString()).set({
              'uID' : uidController.text.toString(),
              'pID' : widget.propertyID.toString(),
            });

            await FirebaseFirestore.instance.collection('Rent').doc(uidController.text.toString()).collection('UnderProperty').doc(widget.propertyID.toString()).set({
              'pID' : widget.propertyID.toString(),
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerRentAssign(propertyID: widget.propertyID, propertyName: widget.propertyName,),),);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  backgroundColor: Colors.pinkAccent,
                  title: Text('No User Found'),
                );
              },
            );
          }
        }),
      );
    } catch (e) {
      print(e);
    }
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
        title: const Text('Owner Add Renter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerRentAssign(propertyID: widget.propertyID, propertyName: widget.propertyName,),),);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter User ID';
                    }
                    return null;
                  },
                  controller: uidController,
                  decoration: const InputDecoration(
                      labelText: "User ID"
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "ADD",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
