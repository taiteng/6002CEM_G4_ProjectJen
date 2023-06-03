import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner/owner_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/owner_task_completion_widget.dart';

class OwnerViewUserTaskCompletion extends StatefulWidget {

  final String pName, pID, taskID;

  const OwnerViewUserTaskCompletion({
    Key? key,
    required this.pName,
    required this.pID,
    required this.taskID,
  }) : super(key: key);

  @override
  State<OwnerViewUserTaskCompletion> createState() => _OwnerViewUserTaskCompletionState();
}

class _OwnerViewUserTaskCompletionState extends State<OwnerViewUserTaskCompletion> {

  List<String> _taskCompletionIDs = [];

  Future getTaskCompletionIDs() async{
    await FirebaseFirestore.instance.collection('TaskCompletion').get().then(
          (snapshot) => snapshot.docs.forEach((taskComp) {
        if (taskComp.exists) {
          if(taskComp['tID'] == widget.taskID){
            _taskCompletionIDs.add(taskComp.reference.id);
          }
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        title: Text('${widget.pName}: Task Completion'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerTask(),),);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getTaskCompletionIDs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _taskCompletionIDs.length,
                        itemBuilder: (context, index){
                          return OwnerTaskCompletionWidget(taskCompletionID: _taskCompletionIDs[index],);
                        },
                      );
                    }
                    else {
                      return const Text("loading");
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
