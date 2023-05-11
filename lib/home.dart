import 'package:flutter/material.dart';
import 'package:projectjen/user_get_recently_viewed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _property = FirebaseFirestore.instance.collection('Property').snapshots();

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
                height: 20,
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
              StreamBuilder(
                stream: _property,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['address']),
                      );
                    }).toList(),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
