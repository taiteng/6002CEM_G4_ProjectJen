import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/model/property_list_model.dart';
import 'package:projectjen/pages/owner/owner_view_property_details.dart';

class GetOwnerProperty extends StatelessWidget {

  final String propertyID;

  const GetOwnerProperty({Key? key, required this.propertyID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _property = FirebaseFirestore.instance.collection('Property');

    return FutureBuilder<DocumentSnapshot>(
      future: _property.doc(propertyID).get(),
      builder: ((context, snapshot){
      if (snapshot.connectionState == ConnectionState.done){
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: (){
                PropertyListModel _propertyListModel = PropertyListModel(
                  PropertyID: data['PropertyID'],
                  Name: data['Name'],
                  Date: data['Date'],
                  Address: data['Address'],
                  Amenities: data['Amenities'],
                  Category: data['Category'],
                  Facilities: data['Facilities'],
                  Contact: data['Contact'],
                  Image: data['Image'],
                  State: data['State'],
                  SalesType: data['SalesType'],
                  Price: data['Price'],
                  LotSize: data['LotSize'],
                  NumOfVisits: data['NumOfVisits'],
                  Bedrooms: data['Beds'],
                  Bathrooms: data['Bathrooms'],
                  OID: data['OID'],
                );

                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerViewPropertyDetails(pModel: _propertyListModel,),),);
              },
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                child: Column(
                  children: [
                    Stack(
                      children : [
                        Container(
                          height : 150,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            data['Image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Text(
                                data['Name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    data['Address'],
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Container(
                                      child: data["SalesType"] == "Rent"
                                          ? Text(
                                        "RM${data["Price"]}/month",
                                        style: const TextStyle(fontSize: 12),
                                      )
                                          : Text(
                                        "RM${data["Price"]}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Date Published: " + data['Date'],
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 10,
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
            ),
          ),
        );
      }
      else{
        return Text('Loading...');
      }
    }),);
  }
}
