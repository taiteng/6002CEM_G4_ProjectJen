import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/user_task_widget.dart';

class UserTask extends StatefulWidget {
  const UserTask({Key? key}) : super(key: key);

  @override
  State<UserTask> createState() => _UserTaskState();
}

class _UserTaskState extends State<UserTask> {
  List<String> _tIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future getPropertyIDs() async{
    final rentPropertySnapshot = await FirebaseFirestore.instance.collection('Rent').doc(user?.uid.toString()).collection('UnderProperty').get();

    for (final rentProperties in rentPropertySnapshot.docs) {
      if (rentProperties.exists) {
        final taskSnapshot = await FirebaseFirestore.instance
            .collection('Task')
            .where('pID', isEqualTo: rentProperties.reference.id)
            .get();

        for (final tDoc in taskSnapshot.docs) {
          if (tDoc.exists) {
            _tIDs.add(tDoc.reference.id);
          } else {
            print("Ntg to see here");
          }
        }
      } else {
        print("0");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder(
          future: getPropertyIDs(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: _tIDs.length,
                itemBuilder: (context, index){
                  return UserTasksWidget(taskID: _tIDs[index],);
                },
              );
            }
            else {
              return const Text("loading");
            }
          }
      ),
    );
  }
}
