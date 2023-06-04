import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'review_card.dart';

class ReviewWidget extends StatefulWidget {
  final String id, imageURL;

  const ReviewWidget({super.key, required this.id, required this.imageURL});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  Stream<QuerySnapshot> getReviews() async* {
    //1. Get documents from "Reviews"
    final Stream<QuerySnapshot> reviews = FirebaseFirestore.instance
        .collection('Reviews')
        .where(FieldPath.documentId, isEqualTo: widget.id.toString())
        .snapshots();

    //2. Get the data and return to stream"
    yield* reviews;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: getReviews(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return Container(
                      height: 100,
                      child: ListView(
                        primary: false,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()!
                          as Map<String, dynamic>;

                          return ReviewCard(
                            pid: widget.id.toString(),
                            imageUrl: widget.imageURL.toString(),
                            name: data['Name'],
                            rating: data['Rating'],
                            comment: data['Comment'],
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Text("ADSAD");
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
