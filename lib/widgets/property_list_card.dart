import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../pages/property_detail.dart';

class PropertyListCard extends StatefulWidget {
  final String imageURL, name, address, date, id, category, facilities, contact, state, salesType, amenities;
  final int price, lotSize, numOfVisits, beds, bathrooms;

  const PropertyListCard({
    Key? key,
    required this.imageURL,
    required this.name,
    required this.address,
    required this.date,
    required this.price,
    required this.id,
    required this.category,
    required this.facilities,
    required this.contact,
    required this.salesType,
    required this.amenities,
    required this.lotSize,
    required this.numOfVisits,
    required this.beds,
    required this.bathrooms,
    required this.state,
  }) : super(key: key);

  @override
  _PropertyListCardState createState() => _PropertyListCardState();
}

class _PropertyListCardState extends State<PropertyListCard> {
  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  bool isFavourite = false;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    checkFavouriteProperty();
  }

  // Check if the current propertyID exists in Firestore
  Future<void> checkFavouriteProperty() async {

    final propertyIDSnapshot = await FirebaseFirestore.instance
        .collection('Favourite')
        .doc(user?.uid.toString())
        .collection('FavouriteProperty')
        .doc(widget.id)
        .get();

    setState(() {
      isFavourite = propertyIDSnapshot.exists; //return true if exist, else false
    });
  }

  // Toggle the favourite status of the property
  Future<void> operationFavouriteProperty() async {
    final favouriteRef = FirebaseFirestore.instance
        .collection("Favourite")
        .doc(user?.uid.toString())
        .collection("FavouriteProperty")
        .doc(widget.id);

    if (isFavourite) {
      await favouriteRef.delete();
    } else {
      await favouriteRef.set({'PID': widget.id});
    }

    setState(() {
      isFavourite = !isFavourite;
    });
  }

  Future<void> insertIntoRecentlyViewedAndIncreaseNumOfVisits() async{
    try{
      await FirebaseFirestore.instance.collection('RecentlyViewed').doc(user?.uid.toString()).collection('PropertyIDs').doc(widget.id.toString()).set({
        'Date' : currentDate.toString(),
        'pID' : widget.id.toString(),
      });

      await FirebaseFirestore.instance.collection('Property').doc(widget.id.toString()).set({
        'Name' : widget.name,
        'LotSize' : widget.lotSize,
        'Price' : widget.price,
        'Address' : widget.address,
        'Amenities' : widget.amenities,
        'Facilities' : widget.facilities,
        'Image' : widget.imageURL,
        'Category' : widget.category,
        'SalesType' : widget.salesType,
        'State' : widget.state,
        'NumOfVisits' : (widget.numOfVisits + 1),
        'Date' : widget.date.toString(),
        'PropertyID' : widget.id,
        'Contact' : widget.contact,
        'Beds' : widget.beds,
        'Bathrooms' : widget.bathrooms,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await insertIntoRecentlyViewedAndIncreaseNumOfVisits();

        Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetail(
          id: this.widget.id,
          name: this.widget.name,
          address: this.widget.address,
          date: this.widget.date,
          price: this.widget.price,
          imageURL: this.widget.imageURL,
          category: this.widget.category,
          facilities: this.widget.facilities,
          contact: this.widget.contact,
          salesType: this.widget.salesType,
          amenities: this.widget.amenities,
          lotSize: this.widget.lotSize,
          beds: this.widget.beds,
          bathrooms: this.widget.bathrooms,
          state: this.widget.state,
          numOfVisits: this.widget.numOfVisits,
        ),),);
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 1,
            shadowColor: Colors.black,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.imageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: isFavourite //If database got the property, return the favourite else not favourite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                        onPressed: operationFavouriteProperty,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Colors.grey,
                              ),
                              Text(
                                widget.address,
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "RM" + widget.price.toString() + "/month",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Date Published: " + widget.date,
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
