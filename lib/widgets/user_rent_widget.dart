import 'package:flutter/material.dart';
import 'package:projectjen/model/user_rent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRentWidget extends StatelessWidget {

  final UserRentModel userRentModel;
  final String propertyID;

  UserRentWidget({
    Key? key,
    required this.userRentModel,
    required this.propertyID,
  }) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  deleteUser() async{
    try{
      final docUser = FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('RentUserID').doc(userRentModel.UID.toString());
      final docRentUser = FirebaseFirestore.instance.collection('Rent').doc(userRentModel.UID.toString()).collection('UnderProperty').doc(propertyID.toString());
      await docUser.delete();
      await docRentUser.delete();
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 4,
              color: Colors.grey,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userRentModel.profileURL.toString(),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userRentModel.username.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userRentModel.UID.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              RawMaterialButton(
                onPressed: () {
                  deleteUser();
                },
                elevation: 0.0,
                fillColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
