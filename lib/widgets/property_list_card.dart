import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyListCard extends StatefulWidget {
  final String imageURL, name, address, date, id;
  final int price;

  const PropertyListCard({
    Key? key,
    required this.imageURL,
    required this.name,
    required this.address,
    required this.date,
    required this.price,
    required this.id,
  }) : super(key: key);

  @override
  _PropertyListCardState createState() => _PropertyListCardState();
}

class _PropertyListCardState extends State<PropertyListCard> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
