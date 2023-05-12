import 'package:projectjen/owner_edit_property.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectjen/owner_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerViewPropertyDetails extends StatefulWidget {

  final String propertyID, name, address, amenities, category, facilities, image, date, state, salesType;
  final int price, lotSize, numOfVisits;

  const OwnerViewPropertyDetails({Key? key,
    required this.propertyID,
    required this.name,
    required this.address,
    required this.amenities,
    required this.category,
    required this.facilities,
    required this.image,
    required this.date,
    required this.state,
    required this.salesType,
    required this.price,
    required this.lotSize,
    required this.numOfVisits,
  }) : super(key: key);

  @override
  State<OwnerViewPropertyDetails> createState() => _OwnerViewPropertyDetailsState();
}

class _OwnerViewPropertyDetailsState extends State<OwnerViewPropertyDetails> {

  @override
  Widget build(BuildContext context) {
    CollectionReference _property = FirebaseFirestore.instance.collection('Property');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Property Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome(),),);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerEditProperty(
            propertyID: widget.propertyID.toString(),
            name: widget.name.toString(),
            date: widget.date.toString(),
            address: widget.address.toString(),
            amenities: widget.amenities.toString(),
            category: widget.category.toString(),
            facilities: widget.facilities.toString(),
            image: widget.image.toString(),
            state: widget.state.toString(),
            salesType: widget.salesType.toString(),
            price: widget.price,
            lotSize: widget.lotSize,
            numOfVisits: widget.numOfVisits,
          ),),);
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.edit),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _property.doc(widget.propertyID).get(),
        builder: ((context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data['PropertyID']),
                  Text(data['Name']),
                  Text(data['Address']),
                  Text(data['Date']),
                  Text(data['Price'].toString()),
                  Text(data['Image']),
                ],
              ),
            );
          }
          else{
            return Text('Loading...');
          }
        }),),
    );
  }
}
