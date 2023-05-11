import 'package:flutter/material.dart';
import 'package:projectjen/user_get_recently_viewed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> propertyIDs = [];

  Future getPropertyIDs() async{
    await FirebaseFirestore.instance.collection('Property').where('salesType', isEqualTo: 'sale',).get().then(
          (snapshot) => snapshot.docs.forEach((properties) {
            propertyIDs.add(properties.reference.id);
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getPropertyIDs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: propertyIDs.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.home),
                              tileColor: Colors.yellowAccent,
                              title: GetRecentlyViewed(propertyID: propertyIDs[index],),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Text("loading");
                    }
                  }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
