import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewCard extends StatefulWidget {
  final String pid, name, rating, comment, imageUrl;

  ReviewCard(
      {Key? key,
      required this.pid,
      required this.name,
      required this.rating,
      required this.imageUrl,
      required this.comment})
      : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 350,
              height: 100,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: TextStyle(fontSize: 15,),),
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: double.parse(widget.rating),
                        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
                        onRatingUpdate: (double rating) {},
                      ),
                      SizedBox(height: 10,),
                      Text(widget.comment, style: TextStyle(fontSize: 15,),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
