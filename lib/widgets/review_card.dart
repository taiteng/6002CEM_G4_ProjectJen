import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ReviewCard extends StatefulWidget {
  final String pid, name, rating, comment;

  const ReviewCard(
      {Key? key,
      required this.pid,
      required this.name,
      required this.rating,
      required this.comment})
      : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();

}

class _ReviewCardState extends State<ReviewCard> {
  final _dialog = RatingDialog(
    title: Text("Rating Dialog"),
    message: Text("Tap a star to set your rating."),
    image: Image.asset(
      "assets/images/logo.png",
      width: 60,
      height: 60,
    ),
    submitButtonText: 'Submit',
    onSubmitted: (response) {
      print("Rating: ${response.rating}, comment: ${response.comment}");
    },
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Card(
                elevation: 2,
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Reviews"),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => _dialog,
                            );
                          },
                          child: const Text(
                            "Write a Review",
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        ),
                      ],
                    )
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
