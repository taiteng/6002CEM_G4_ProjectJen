import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class RatingBarWidget extends StatefulWidget {
  final String id;

  const RatingBarWidget({super.key, required this.id});

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  double totalAvgRating = 0.0;

  void averageRating() async {
    List<double> avgRating = [];

    await FirebaseFirestore.instance
        .collection("Reviews")
        .where(FieldPath.documentId, isEqualTo: widget.id)
        .get()
        .then((snapshot) => snapshot.docs.forEach((rating) {
          if(rating.exists) {
            avgRating.add(double.parse(rating.data()["Rating"].toString()));
          } else
            print("No Ratings");
        }));

    if (mounted) {
      if(avgRating.length == 0){
        return null;
      }else{
        setState(() {
          totalAvgRating = avgRating.average;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    averageRating();

    return RatingBar.builder(
      ignoreGestures: true,
      itemSize: 20,
      initialRating: double.parse(totalAvgRating.toString()),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (double rating) {},
    );
  }
}
