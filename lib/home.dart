import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/home_property_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _property =
  FirebaseFirestore.instance.collection('Property').orderBy('date', descending: true).snapshots();

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
              SizedBox(
                height: 15,
              ),
              Row( //Buttons for Sell and buy
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(buyButtonClicked)
                    ConstrainedBox(
                      constraints:
                      BoxConstraints.tightFor(width: 100, height: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = true;
                              sellButtonClicked = false;
                            });
                          },
                          child: Text(
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
                      BoxConstraints.tightFor(width: 100, height: 40),
                      child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = true;
                              sellButtonClicked = false;
                            });
                          },
                          child: Text(
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
                      BoxConstraints.tightFor(width: 100, height: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = false;
                              sellButtonClicked = true;
                            });
                          },
                          child: Text(
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
                      BoxConstraints.tightFor(width: 100, height: 40),
                      child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              buyButtonClicked = false;
                              sellButtonClicked = true;
                            });
                          },
                          child: Text(
                            "RENT",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ) //BUY Button
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 0.8),
                        ),
                        hintText: "E.g. Penang Condominium",
                        prefixIcon: Icon(
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
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey,
                thickness: .2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Recent Properties",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _property,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      return HomePropertyList(
                        name: data['name'],
                        address: data['address'],
                        date: data['date'],
                        price: data['price'],
                        imageURL: data['image'],
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
