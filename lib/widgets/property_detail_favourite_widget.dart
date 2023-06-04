import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyDetailFavouriteWidget extends StatefulWidget {
  final String id;

  const PropertyDetailFavouriteWidget({super.key, required this.id});

  @override
  State<PropertyDetailFavouriteWidget> createState() => _FavouritePropertyDetailWidgetState();
}

class _FavouritePropertyDetailWidgetState extends State<PropertyDetailFavouriteWidget> {

  @override
  void initState() {
    super.initState();
    checkFavouriteProperty();
  }

  bool isFavourite = false;
  final User? user = FirebaseAuth.instance.currentUser;

  // Check if the current propertyID exists in Firestore
  Future<void> checkFavouriteProperty() async {
    final propertyIDSnapshot = await FirebaseFirestore.instance
        .collection('Favourite')
        .doc(user?.uid.toString())
        .collection('FavouriteProperty')
        .doc(widget.id)
        .get();

    setState(() {
      isFavourite =
          propertyIDSnapshot.exists; //return true if exist, else false
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
    return SizedBox(
      height: 60,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white,
        ),
        child: IconButton(
          icon:
          isFavourite //If database got the property, return the favourite else not favourite
              ? const Icon(
            Icons.favorite,
            color: Colors.red,
          )
              : const Icon(
            Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            operationFavouriteProperty();
          },
        ),
      ),
    );
  }
}
