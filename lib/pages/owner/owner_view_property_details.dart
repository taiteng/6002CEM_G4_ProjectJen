import 'package:projectjen/pages/owner/owner_edit_property.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner/owner_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerViewPropertyDetails extends StatefulWidget {

  final String propertyID, name, address, amenities, category, facilities, contact, image, date, state, salesType;
  final int price, lotSize, numOfVisits;

  const OwnerViewPropertyDetails({Key? key,
    required this.propertyID,
    required this.name,
    required this.address,
    required this.amenities,
    required this.category,
    required this.facilities,
    required this.contact,
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

  final User? user = FirebaseAuth.instance.currentUser;

  List<String> _uRVIDs = [];
  List<String> _uFIDs = [];

  int RecentlyViewedCount = 0;
  int FavouriteCount = 0;

  getRecentlyViewedUserID() async{
    await FirebaseFirestore.instance.collection('RecentlyViewed').get().then(
          (snapshot) => snapshot.docs.forEach((users) {
        if (users.exists) {
          _uRVIDs.add(users.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  getFavouriteUserID() async{
    await FirebaseFirestore.instance.collection('Favourite').get().then(
          (snapshot) => snapshot.docs.forEach((users) {
        if (users.exists) {
          _uFIDs.add(users.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }
  
  deleteProperty() async {
    try{
      final docProperty = FirebaseFirestore.instance.collection('Property').doc(widget.propertyID.toString());
      await docProperty.delete();

      final docOwnerProperty = FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').doc(widget.propertyID.toString());
      await docOwnerProperty.delete();

      await getRecentlyViewedUserID();

      while(RecentlyViewedCount < _uRVIDs.length){
        await FirebaseFirestore.instance.collection('RecentlyViewed').doc(_uRVIDs[RecentlyViewedCount]).collection('PropertyIDs').get().then(
              (snapshot) => snapshot.docs.forEach((propertyID) async {
            if (propertyID.exists) {
              if(propertyID.reference.id.toString() == widget.propertyID.toString()){
                final RecentlyViewedPropertyID = FirebaseFirestore.instance.collection('RecentlyViewed').doc(_uRVIDs[RecentlyViewedCount]).collection('PropertyIDs').doc(widget.propertyID.toString());
                await RecentlyViewedPropertyID.delete();
              }
            } else {
              print("Ntg to see here");
            }
          }),
        );

        RecentlyViewedCount++;
      }

      await getFavouriteUserID();

      while(FavouriteCount < _uFIDs.length){
        await FirebaseFirestore.instance.collection('Favourite').doc(_uFIDs[FavouriteCount]).collection('FavouriteProperty').get().then(
              (snapshot) => snapshot.docs.forEach((propertyID) async {
            if (propertyID.exists) {
              if(propertyID.reference.id.toString() == widget.propertyID.toString()){
                final FavouritePropertyID = FirebaseFirestore.instance.collection('Favourite').doc(_uFIDs[FavouriteCount]).collection('FavouriteProperty').doc(widget.propertyID.toString());
                await FavouritePropertyID.delete();
              }
            } else {
              print("Ntg to see here");
            }
          }),
        );

        FavouriteCount++;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome(),),);
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _property = FirebaseFirestore.instance.collection('Property');

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
        title: const Text('Owner Property Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerHome(),),);
          },
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin:EdgeInsets.all(10),
            child: FloatingActionButton(
              heroTag: 'EditBtn',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerEditProperty(
                  propertyID: widget.propertyID.toString(),
                  name: widget.name.toString(),
                  date: widget.date.toString(),
                  address: widget.address.toString(),
                  amenities: widget.amenities.toString(),
                  category: widget.category.toString(),
                  facilities: widget.facilities.toString(),
                  contact : widget.contact.toString(),
                  image: widget.image.toString(),
                  state: widget.state.toString(),
                  salesType: widget.salesType.toString(),
                  price: widget.price,
                  lotSize: widget.lotSize,
                  numOfVisits: widget.numOfVisits,
                ),),);
              },
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.edit),
            ),
          ),

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                heroTag: 'DeleteBtn',
                onPressed: deleteProperty,
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.delete),
              )
          ),

          // Add more buttons here
        ],
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
