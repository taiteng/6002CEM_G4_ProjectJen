import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/property_list_card.dart';

class GetRecentlyViewed extends StatelessWidget {

  final String propertyID;

  const GetRecentlyViewed({Key? key, required this.propertyID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _property = FirebaseFirestore.instance.collection('Property');

    return FutureBuilder<DocumentSnapshot>(
      future: _property.doc(propertyID).get(),
      builder: ((context, snapshot){
      if (snapshot.connectionState == ConnectionState.done){
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return PropertyListCard(
          name: data['Name'],
          address: data['Address'],
          date: data['Date'],
          price: data['Price'],
          imageURL: data['Image'],
        );
      }
      else{
        return Text('Loading...');
      }
    }),);
  }
}
