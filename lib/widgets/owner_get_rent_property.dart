import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/pages/owner/owner_rent_assign.dart';

class GetOwnerRentProperty extends StatefulWidget {

  final String propertyID;

  const GetOwnerRentProperty({Key? key, required this.propertyID}) : super(key: key);

  @override
  State<GetOwnerRentProperty> createState() => _GetOwnerRentPropertyState();
}

class _GetOwnerRentPropertyState extends State<GetOwnerRentProperty> {

  @override
  Widget build(BuildContext context) {

    CollectionReference _property = FirebaseFirestore.instance.collection('Property');

    return FutureBuilder<DocumentSnapshot>(
      future: _property.doc(widget.propertyID).get(),
      builder: ((context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerRentAssign(
                  propertyID: data['PropertyID'],
                ),),);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 4,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Image.network(
                        data['Image'],
                        height : 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['Name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Colors.grey,
                              ),
                              Text(
                                data['Address'],
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            "Date Published: " + data['Date'],
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "RM" + data['Price'].toString() + "/month",
                              style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else{
          return const Text('Loading...');
        }
      }),);
  }
}