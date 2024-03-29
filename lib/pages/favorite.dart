import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/favourite_property.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getFavouriteProperty();
  }

  void refreshFavouritePage(){
    getFavouriteProperty();
    setState(() {

    });
  }

  Stream<QuerySnapshot> getFavouriteProperty() async* {
    List<String> propertyIDs = [];
    List<String> favouriteIDs = [];

    //1. Get Ids from "Favourite"
    await FirebaseFirestore.instance
        .collection('Favourite')
        .doc(user?.uid.toString())
        .collection('FavouriteProperty')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              favouriteIDs.add(element.id);
            }));

    //2. Get Ids from "Favourite"
    await FirebaseFirestore.instance
        .collection('Property')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              propertyIDs.add(element.id);
            }));

    //3. Find the "Properties" ids that stored in "Favourite"
    final Stream<QuerySnapshot> favouriteProperty = FirebaseFirestore.instance
        .collection("Property")
        .where(FieldPath.documentId, whereIn: favouriteIDs)
        .snapshots();
    //4. Get the data and return to stream"
    yield* favouriteProperty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ClipRRect(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 20.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: getFavouriteProperty(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.error_outline_outlined,
                                  size: 50,
                                ),
                                Text(
                                  "Oops",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "You don't have favourite properties.",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }else if(snapshot.connectionState == ConnectionState.active){
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                              return FavouriteProperty(
                                id: data['PropertyID'],
                                name: data['Name'],
                                address: data['Address'],
                                date: data['Date'],
                                price: data['Price'],
                                imageURL: data['Image'],
                                refreshFavourite: refreshFavouritePage, //recall the page and load new data
                              );
                            }).toList(),
                          );

                        }else{
                          return const Text("Error");
                        }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
