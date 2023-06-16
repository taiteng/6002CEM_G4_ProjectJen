import 'package:projectjen/model/property_list_model.dart';
import 'package:projectjen/pages/owner/owner_edit_property.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner/owner_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectjen/widgets/rating_bar_widget.dart';

class OwnerViewPropertyDetails extends StatefulWidget {

  final PropertyListModel pModel;

  const OwnerViewPropertyDetails({
    Key? key,
    required this.pModel,
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

  deleteFromRecentlyViewed() async {
    while(RecentlyViewedCount < _uRVIDs.length){
      await FirebaseFirestore.instance.collection('RecentlyViewed').doc(_uRVIDs[RecentlyViewedCount]).collection('PropertyIDs').get().then(
            (snapshot) => snapshot.docs.forEach((propertyID) async {
          if (propertyID.exists) {
            if(propertyID.reference.id.toString() == widget.pModel.PropertyID.toString()){
              final RecentlyViewedPropertyID = FirebaseFirestore.instance.collection('RecentlyViewed').doc(_uRVIDs[RecentlyViewedCount]).collection('PropertyIDs').doc(widget.pModel.PropertyID.toString());
              await RecentlyViewedPropertyID.delete();
            }
          } else {
            print("Ntg to see here");
          }
        }),
      );

      RecentlyViewedCount++;
    }
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

  deleteFromFavourite() async{
    while(FavouriteCount < _uFIDs.length){
      await FirebaseFirestore.instance.collection('Favourite').doc(_uFIDs[FavouriteCount]).collection('FavouriteProperty').get().then(
            (snapshot) => snapshot.docs.forEach((propertyID) async {
          if (propertyID.exists) {
            if(propertyID.reference.id.toString() == widget.pModel.PropertyID.toString()){
              final FavouritePropertyID = FirebaseFirestore.instance.collection('Favourite').doc(_uFIDs[FavouriteCount]).collection('FavouriteProperty').doc(widget.pModel.PropertyID.toString());
              await FavouritePropertyID.delete();
            }
          } else {
            print("Ntg to see here");
          }
        }),
      );

      FavouriteCount++;
    }
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

  deleteFromRent() async{
    while(RentCount < _uRIDs.length){
      await FirebaseFirestore.instance.collection('Rent').doc(_uRIDs[RentCount]).collection('UnderProperty').get().then(
            (snapshot) => snapshot.docs.forEach((propertyID) async {
          if (propertyID.exists) {
            if(propertyID.reference.id.toString() == widget.pModel.PropertyID.toString()){
              final RentPropertyID = FirebaseFirestore.instance.collection('Rent').doc(_uRIDs[RentCount]).collection('UnderProperty').doc(propertyID.reference.id.toString());
              await RentPropertyID.delete();
            }
          } else {
            print("Ntg to see here");
          }
        }),
      );

      FavouriteCount++;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OwnerHome(),));
  }

  deleteFromReviews() async{
    await FirebaseFirestore.instance.collection('Reviews').get().then(
          (snapshot) => snapshot.docs.forEach((property) async {
        if (property.exists) {
          if(property.reference.id.toString() == widget.pModel.PropertyID.toString()){
            final ReviewsPropertyID = FirebaseFirestore.instance.collection('Reviews').doc(widget.pModel.PropertyID.toString());
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
    QuerySnapshot taskQuerySnapshot = await collectionRef.where('pID', isEqualTo: widget.pModel.PropertyID).get();

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
      final docProperty = FirebaseFirestore.instance.collection('Property').doc(widget.pModel.PropertyID.toString());
      await docProperty.delete();
      final docOwnerProperty = FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').doc(widget.pModel.PropertyID.toString());
      await docOwnerProperty.delete();
      await getRecentlyViewedUserID();
      await deleteFromRecentlyViewed();
      await getFavouriteUserID();
      await deleteFromFavourite();
      await deleteFromReviews();
      await deleteFromTaskAndTaskCompletion();
      await getRentUserID();
      await deleteFromRent();
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
                  propertyID: widget.pModel.PropertyID.toString(),
                  name: widget.pModel.Name.toString(),
                  date: widget.pModel.Date.toString(),
                  address: widget.pModel.Address.toString(),
                  amenities: widget.pModel.Amenities.toString(),
                  category: widget.pModel.Category.toString(),
                  facilities: widget.pModel.Facilities.toString(),
                  contact : widget.pModel.Contact.toString(),
                  image: widget.pModel.Image.toString(),
                  state: widget.pModel.State.toString(),
                  salesType: widget.pModel.SalesType.toString(),
                  price: widget.pModel.Price,
                  lotSize: widget.pModel.LotSize,
                  numOfVisits: widget.pModel.NumOfVisits,
                  beds: widget.pModel.Bedrooms,
                  bathrooms: widget.pModel.Bathrooms,
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
                widget.pModel.Image,
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
                            widget.pModel.Name,
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
                                widget.pModel.NumOfVisits.toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          RatingBarWidget(id: widget.pModel.PropertyID),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Text(
                                widget.pModel.Address,
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
                          child: widget.pModel.SalesType == "Rent"
                              ? Text(
                            "RM${widget.pModel.Price}/month",
                            style: const TextStyle(fontSize: 12),
                          )
                              : Text(
                            "RM${widget.pModel.Price}",
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
                                "  ${widget.pModel.Bedrooms.toString()} Beds",
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
                                "  ${widget.pModel.Bathrooms.toString()} Bathrooms",
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
                                "  ${widget.pModel.LotSize} Sqft",
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
                            "${widget.pModel.SalesType} Details",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Amenities: ${widget.pModel.Amenities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "LotSize: ${widget.pModel.LotSize}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Category: ${widget.pModel.Category}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Facilities: ${widget.pModel.Facilities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Feel free to contact me at ${widget.pModel.Contact} for more information!",
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
