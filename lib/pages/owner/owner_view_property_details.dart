import 'package:projectjen/pages/owner/owner_edit_property.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner/owner_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectjen/widgets/rating_bar_widget.dart';

class OwnerViewPropertyDetails extends StatefulWidget {

  final String propertyID, name, address, amenities, category, facilities, contact, image, date, state, salesType;
  final int price, lotSize, numOfVisits, beds, bathrooms;

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
    required this.beds,
    required this.bathrooms,
  }) : super(key: key);

  @override
  State<OwnerViewPropertyDetails> createState() => _OwnerViewPropertyDetailsState();
}

class _OwnerViewPropertyDetailsState extends State<OwnerViewPropertyDetails> {

  final User? user = FirebaseAuth.instance.currentUser;

  List<String> _uRVIDs = [];
  List<String> _uFIDs = [];
  List<String> _uRIDs = [];

  int RecentlyViewedCount = 0;
  int FavouriteCount = 0;
  int RentCount = 0;

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

  getRentUserID() async{
    await FirebaseFirestore.instance.collection('Rent').get().then(
          (snapshot) => snapshot.docs.forEach((users) {
        if (users.exists) {
          _uRIDs.add(users.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  deleteFromReviews() async{
    await FirebaseFirestore.instance.collection('Reviews').get().then(
          (snapshot) => snapshot.docs.forEach((property) async {
        if (property.exists) {
          if(property.reference.id.toString() == widget.propertyID.toString()){
            final ReviewsPropertyID = FirebaseFirestore.instance.collection('Reviews').doc(widget.propertyID.toString());
            await ReviewsPropertyID.delete();
          }
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  deleteFromTaskAndTaskCompletion() async{
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Tasks');
    QuerySnapshot taskQuerySnapshot = await collectionRef.where('pID', isEqualTo: widget.propertyID).get();

    for (QueryDocumentSnapshot docTaskSnapshot in taskQuerySnapshot.docs) {

      CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskCompletion');
      QuerySnapshot taskCompletionQuerySnapshot = await collectionRef.where('tID', isEqualTo: docTaskSnapshot.reference.id).get();

      for (QueryDocumentSnapshot docTaskCompletionSnapshot in taskCompletionQuerySnapshot.docs) {
        await docTaskCompletionSnapshot.reference.delete();
      }

      await docTaskSnapshot.reference.delete();
    }
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

      await deleteFromReviews();

      await deleteFromTaskAndTaskCompletion();

      await getRentUserID();

      while(RentCount < _uRIDs.length){
        await FirebaseFirestore.instance.collection('Rent').doc(_uRIDs[RentCount]).collection('UnderProperty').get().then(
              (snapshot) => snapshot.docs.forEach((propertyID) async {
            if (propertyID.exists) {
              if(propertyID.reference.id.toString() == widget.propertyID.toString()){
                final RentPropertyID = FirebaseFirestore.instance.collection('Rent').doc(_uRIDs[RentCount]).collection('UnderProperty').doc(widget.propertyID.toString());
                await RentPropertyID.delete();
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
                  beds: widget.beds,
                  bathrooms: widget.bathrooms,
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
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey[500],
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.numOfVisits.toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          RatingBarWidget(id: widget.propertyID),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Text(
                                widget.address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          child: widget.salesType == "Rent"
                              ? Text(
                            "RM${widget.price}/month",
                            style: const TextStyle(fontSize: 12),
                          )
                              : Text(
                            "RM${widget.price}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bed,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.beds.toString()} Beds",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bathtub,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.bathrooms.toString()} Bathrooms",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.landscape,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.lotSize} Sqft",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.salesType} Details",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Amenities: ${widget.amenities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "LotSize: ${widget.lotSize}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Category: ${widget.category}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Facilities: ${widget.facilities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Feel free to contact me at ${widget.contact} for more information!",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
