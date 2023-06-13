import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/pages/search.dart';
import 'package:projectjen/widgets/property_list_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool sellButtonClicked = false;
  bool buyButtonClicked = true;

  String _propertyType = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  //Get properties by date in descending order
  final Stream<QuerySnapshot> _property = FirebaseFirestore.instance
      .collection('Property')
      .orderBy('Date', descending: true)
      .snapshots();

  void beginSearch(String value) {
    if (value.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Search(searchControllerText: _searchController, propertyType: _propertyType,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                        hintText: "Search Penang Condominium",
                                        hintStyle: const TextStyle(
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.deepOrangeAccent,
                                          size: 20,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (value) {
                                        beginSearch(value);
                                      },
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                      ),
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
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Text(
                            "Recent Properties",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: _property,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        return ListView(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            return PropertyListCard(
                              id: data['PropertyID'],
                              oid: data['OID'],
                              name: data['Name'],
                              address: data['Address'],
                              date: data['Date'],
                              price: data['Price'],
                              imageURL: data['Image'],
                              category: data['Category'],
                              state: data['State'],
                              facilities: data['Facilities'],
                              salesType: data['SalesType'],
                              amenities: data['Amenities'],
                              lotSize: data['LotSize'],
                              numOfVisits: data['NumOfVisits'],
                              beds: data['Beds'],
                              bathrooms: data['Bathrooms'],
                              contact: data['Contact'],
                            );
                          }).toList(),
                        );
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
