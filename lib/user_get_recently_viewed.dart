import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        return Text('Name: ' + data['name'] + ' Facilities: ' + data['facilities']);
      }
      else{
        return Text('Loading...');
      }
    }),);
  }
}
