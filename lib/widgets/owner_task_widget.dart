import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/pages/owner/owner_edit_task.dart';
import 'package:projectjen/pages/owner/owner_task.dart';
import 'package:projectjen/pages/owner/owner_view_user_task_completion.dart';

class OwnerTasksWidget extends StatefulWidget {

  final String tasksID;


  OwnerTasksWidget({Key? key, required this.tasksID}) : super(key: key);

  @override
  State<OwnerTasksWidget> createState() => _OwnerTasksWidgetState();
}

class _OwnerTasksWidgetState extends State<OwnerTasksWidget> {
  final User? user = FirebaseAuth.instance.currentUser;

  deleteTask() async{
    try{
      final docTask = FirebaseFirestore.instance.collection('Task').doc(widget.tasksID);
      await docTask.delete();

      CollectionReference collectionRef = FirebaseFirestore.instance.collection('TaskCompletion');
      QuerySnapshot querySnapshot = await collectionRef.where('tID', isEqualTo: widget.tasksID).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerTask(),),);
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference _tasks = FirebaseFirestore.instance.collection('Task');

    return FutureBuilder<DocumentSnapshot>(
      future: _tasks.doc(widget.tasksID).get(),
      builder: ((context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerViewUserTaskCompletion(taskID: widget.tasksID, pName: data['pName'], pID: data['pID'],),),);
              },
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['Title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              'Under Property: ${data['pName']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              'Due Date: ${data['DueDate']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              data['Description'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerEditTask(
                                taskID: widget.tasksID,
                                title: data['Title'],
                                desc: data['Description'],
                                dueDate: data['DueDate'],
                                pID: data['pID'],
                                pName: data['pName'],
                              ),),);
                            },
                            fillColor: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(4.0),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          RawMaterialButton(
                            onPressed: () {
                              deleteTask();
                            },
                            fillColor: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(4.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else{
          return const Text('Loading...');
        }
      }),);
  }
}
