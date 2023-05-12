import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/property_list_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _property =
  FirebaseFirestore.instance.collection('Property').orderBy('Date', descending: true).snapshots();

  bool sellButtonClicked = false;
  bool buyButtonClicked = true;

  final TextEditingController _searchController = TextEditingController();

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row( //Buttons for Sell and buy
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(buyButtonClicked)
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(width: 100, height: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = true;
                              sellButtonClicked = false;
                            });
                          },
                          child: const Text(
                            "BUY",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ) //BUY Button
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(width: 100, height: 40),
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
                              fontSize: 15,
                            ),
                          ) //BUY Button
                      ),
                    ),

                  if(sellButtonClicked)
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(width: 100, height: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = false;
                              sellButtonClicked = true;
                            });
                          },
                          child: const Text(
                            "RENT",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ) //BUY Button
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(width: 100, height: 40),
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
                              fontSize: 15,
                            ),
                          ) //BUY Button
                      ),
                    )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(width: 0.8),
                        ),
                        hintText: "E.g. Penang Condominium",
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value){
                        //_beginSearch();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.grey,
                thickness: .2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Recent Properties",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _property,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      return HomePropertyList(
                        name: data['Name'],
                        address: data['Address'],
                        date: data['Date'],
                        price: data['Price'],
                        imageURL: data['Image'],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
