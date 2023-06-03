import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerTaskCompletionWidget extends StatelessWidget {
  final String taskCompletionID;

  const OwnerTaskCompletionWidget({
    Key? key,
    required this.taskCompletionID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _taskCompletion =
    FirebaseFirestore.instance.collection('TaskCompletion');

    return FutureBuilder<DocumentSnapshot>(
      future: _taskCompletion.doc(taskCompletionID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 4,
                        color: Colors.grey,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Image.network(
                          data['ImageURL'],
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  data['uName'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  data['Status'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.task_alt,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  data['DateOfCompletion'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
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
              );
            } else {
              return const Text('Data is null');
            }
          } else {
            return const Text('No data');
          }
        } else {
          return const Text('Loading...');
        }
      }),
    );
  }
}
