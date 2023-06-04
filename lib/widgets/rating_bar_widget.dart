import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class RatingBarWidget extends StatefulWidget {
  const RatingBarWidget({super.key});

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  double totalAvgRating = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    averageRating();
  }

  void averageRating() async {
    List<double> avgRating = [];

    await FirebaseFirestore.instance
        .collection("Reviews")
        .get()
        .then((snapshot) => snapshot.docs.forEach((rating) {
      avgRating.add(double.parse(rating.data()["Rating"].toString()));
    }));

    //issue causing setstate error if navigate to property detail and go back
    setState(() {
      totalAvgRating = avgRating.average;
    });
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
