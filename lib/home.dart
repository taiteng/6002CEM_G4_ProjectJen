import 'package:flutter/material.dart';
import 'package:projectjen/hidden_drawer_menu.dart';
import 'package:projectjen/property_list_model.dart';
import 'package:projectjen/user_settings.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CollectionReference _property = FirebaseFirestore.instance.collection('Property');

  Future getPropertyList() async{
    QuerySnapshot querySnapshot = await _property.get();
    final propertyDataList = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(propertyDataList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
            future: _property.get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 100, height: 40),
                            child: OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                  "BUY",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ) //BUY Button
                                ),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 100, height: 40),
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "SELL",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ) //BUY Button
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return const Text("loading");
              }
            }
            ),
      ),
    );
  }
}
