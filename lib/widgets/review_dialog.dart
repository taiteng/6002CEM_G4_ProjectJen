import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewDialog extends StatefulWidget {
  final String pid;

  const ReviewDialog({Key? key, required this.pid}) : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  dynamic username;
  final User? user = FirebaseAuth.instance.currentUser;

  Future getUsername(String? userID) async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Users');

    // Retrieve a specific document by document ID
    DocumentSnapshot documentSnapshot = await collectionRef.doc(userID).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Access the desired field value using the [] operator
      username = data['Username'];
    } else {
      print('Document does not exist');
    }
  }


  @override
  Widget build(BuildContext context) {
    getUsername(user?.uid.toString());

    final _dialog = RatingDialog(
      title: Text("Rating Dialog"),
      message: Text("Tap a star to set your rating."),
      image: Image.asset(
        "assets/images/logo.png",
        width: 300,
        height: 300,
      ),
      submitButtonText: 'Submit',
      onSubmitted: (response) async {
        await FirebaseFirestore.instance.collection("Reviews").doc(widget.pid).set(
            {
              "Name": username,
              "Comment": response.comment,
              "Rating": response.rating.toString(),
              "PID" : widget.pid,
            });
      },
    );


    return ElevatedButton(
      onPressed: () {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => _dialog,
        );
      },
      child: const Text(
        "Write a Review",
        style: TextStyle(color: Colors.lightBlueAccent),
      ),
    );
  }
}

