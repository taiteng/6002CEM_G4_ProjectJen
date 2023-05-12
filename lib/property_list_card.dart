import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:projectjen/owner_view_property_details.dart';

class PropertyListCard extends StatelessWidget {
  final String imageURL, name, address, date;
  final int price;

  const PropertyListCard({Key? key,
    required this.imageURL,
    required this.name,
    required this.address,
    required this.date,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                      imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: LikeButton(
                      size: 25,
                      animationDuration: Duration(milliseconds: 1000),
                      likeBuilder: (isTapped){
                        if(isTapped)
                          return Icon(
                            Icons.favorite,
                            color: Colors.red,
                          );
                        else{
                          return Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          );
                        }
                      },
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
                          name,
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
                              address,
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
                              child: Text(
                                "RM" + price.toString() + "/month",
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 10),
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
                          "Date Published: " + date,
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
    );
  }
}
