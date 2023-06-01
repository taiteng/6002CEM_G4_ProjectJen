import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/property_list_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool sellButtonClicked = false;
  bool buyButtonClicked = true;
  bool isFavourited = false;

  final TextEditingController _searchController = TextEditingController();

  //Get properties by date in descending order
  final Stream<QuerySnapshot> _property = FirebaseFirestore.instance
      .collection('Property')
      .orderBy('Date', descending: true)
      .snapshots();

  //Get current propertyID
  // getCurrentPropertyID() async {
  //   await FirebaseFirestore.instance.doc('Property').collection('PropertyID').get().then(
  //           (snapshot) => snapshot.docs.forEach((propertyID) {
  //             if(propertyID.exists){
  //               propertyIDList.add(propertyID.reference.id);
  //             }else{
  //               print("No id");
  //             }
  //           }));
  // }

  // void _beginSearch() {
  //   String searchQuery = _searchController.text;
  //   if (searchQuery.isNotEmpty) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ResultsScreen(searchQuery),
  //       ),
  //     );
  //   }
  // }

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
                  Row(
                    //Buttons for Sell and buy
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (buyButtonClicked)
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 100, height: 40),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  buyButtonClicked = true;
                                  sellButtonClicked = false;
                                });
                              },
                              child: const Text(
                                "BUY",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15,
                                ),
                              ) //BUY Button
                              ),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 100, height: 40),
                          child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  buyButtonClicked = true;
                                  sellButtonClicked = false;
                                });
                              },
                              child: const Text(
                                "BUY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ) //BUY Button
                              ),
                        ),
                      if (sellButtonClicked)
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 100, height: 40),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  buyButtonClicked = false;
                                  sellButtonClicked = true;
                                });
                              },
                              child: const Text(
                                "RENT",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15,
                                ),
                              ) //BUY Button
                              ),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 100, height: 40),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                buyButtonClicked = false;
                                sellButtonClicked = true;
                              });
                            },
                            child: const Text(
                              "RENT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ), //BUY Button
                          ),
                        ),
                    ],
                  ),
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
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                        hintText: "E.g. Penang Condominium",
                                        hintStyle: TextStyle(
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
                                        //_beginSearch();
                                      },
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.orangeAccent),
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.zero),
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.filter_list_rounded,
                                          color: Colors.white,
                                        ),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Container(
                decoration: BoxDecoration(
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
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const Text(
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            return PropertyListCard(
                              id: data['PropertyID'],
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
