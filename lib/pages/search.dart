import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/property_list_card.dart';
import 'hidden_drawer_menu.dart';

class Search extends StatefulWidget {
  final TextEditingController searchControllerText;
  final String propertyType;

  const Search(
      {super.key,
      required this.searchControllerText,
      required this.propertyType});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchText = "";
  bool filterHighSelection = false;
  bool filterLowSelection = false;
  String salesType = "default";
  late Stream<QuerySnapshot> _property;

  @override
  void dispose() {
    widget.searchControllerText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Retrieve Data based on the variables
    if (filterLowSelection && !filterHighSelection) {
      if(salesType == "default") {
        _property = FirebaseFirestore.instance
          .collection('Property')
          .orderBy("Price")
          .snapshots();
      }else{
        _property = FirebaseFirestore.instance
            .collection('Property')
            .where("SalesType", isEqualTo: salesType)
            .orderBy("Price")
            .snapshots();
      }
    } else if (filterHighSelection && !filterLowSelection) {
      if(salesType == "default") {
        _property = FirebaseFirestore.instance
            .collection('Property')
            .orderBy("Price", descending: true)
            .snapshots();
      }else{
        _property = FirebaseFirestore.instance
            .collection('Property')
            .where("SalesType", isEqualTo: salesType)
            .orderBy("Price", descending: true)
            .snapshots();
      }
    } else if (!filterHighSelection && !filterLowSelection){
      if(salesType == "default") {
        _property = FirebaseFirestore.instance
            .collection('Property')
            .snapshots();
      }else{
        _property = FirebaseFirestore.instance
            .collection('Property')
            .where("SalesType", isEqualTo: salesType)
            .snapshots();
      }
    }

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
        title: const Text('Search Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HiddenDrawer(pageNum: 0),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
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
                                  controller: widget.searchControllerText,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent
                                            .withOpacity(0.7),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
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
                                  onChanged: (value) {
                                    setState(() {
                                      searchText = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(
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
                                          EdgeInsetsGeometry>(EdgeInsets.zero),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              Text("Filter for $searchText"),
                                          content: Container(
                                            height: 250,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        filterLowSelection =
                                                            true;
                                                        filterHighSelection =
                                                            false;
                                                        setState(() {

                                                        });
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Icon(Icons
                                                              .arrow_upward),
                                                          Text(
                                                              "Price: Lowest to Highest"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        filterHighSelection =
                                                            true;
                                                        filterLowSelection =
                                                            false;
                                                        setState(() {

                                                        });
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Icon(Icons
                                                              .arrow_downward),
                                                          Text(
                                                              "Price: Highest to Lowest"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        salesType = "Rent";
                                                        setState(() {

                                                        });
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Text(
                                                              "Rent"),
                                                        ],
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        salesType = "Sell";
                                                        setState(() {

                                                        });
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Text(
                                                              "Sell"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.filter_list_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (filterHighSelection)
                                OutlinedButton(
                                  onPressed: () {
                                    filterHighSelection = false;
                                    filterLowSelection = false;
                                    setState(() {

                                    });
                                  },
                                  child: const Text("Price: Highest to Lowest"),
                                ),
                              if (filterLowSelection)
                                OutlinedButton(
                                  onPressed: () {
                                    filterHighSelection = false;
                                    filterLowSelection = false;
                                    setState(() {

                                    });
                                  },
                                  child: const Text("Price: Lowest to Highest"),
                                ),
                              if (salesType == "Rent")
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      salesType = "default";
                                      setState(() {

                                      });
                                    },
                                    child: const Text("Type: Rent"),
                                  ),
                                ),
                              if (salesType == "Sell")
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      salesType = "default";
                                      setState(() {

                                      });
                                    },
                                    child: const Text("Type: Sell"),
                                  ),
                                ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: _property,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
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

                              //If search parameter is nothing or found
                              if (searchText.isEmpty ||
                                  data['Name']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase()) ||
                                  data['Address']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase()) ||
                                  data['Price']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase()) ||
                                  data['Category']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase()) ||
                                  data['State']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase()) ||
                                  data['SalesType']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(searchText.toLowerCase())) {
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
                              } else {
                                //if parameter did not found anything
                                return const SizedBox.shrink();
                              }
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
      ),
    );
  }
}
