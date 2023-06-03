import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'package:projectjen/pages/owner/owner_add_task.dart';
import 'package:projectjen/pages/owner/owner_home.dart';
import 'package:projectjen/pages/owner/owner_rent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectjen/widgets/owner_task_widget.dart';

class OwnerTask extends StatefulWidget {
  const OwnerTask({Key? key}) : super(key: key);

  @override
  State<OwnerTask> createState() => _OwnerTaskState();
}

class _OwnerTaskState extends State<OwnerTask> {

  List<String> _tIDs = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future getTaskIDs() async{
    await FirebaseFirestore.instance.collection('Task').where('oID', isEqualTo: user?.uid.toString()).get().then(
          (snapshot) => snapshot.docs.forEach((tasks) {
        if (tasks.exists) {
          _tIDs.add(tasks.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.deepOrange,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: GNav(
            backgroundColor: Colors.deepOrange,
            color: Colors.white,
            activeColor: Colors.white,
            gap: 10,
            tabBackgroundColor: Colors.amber,
            padding: EdgeInsets.all(16),
            selectedIndex: 2,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerHome(),),);
                },
              ),
              GButton(
                icon: Icons.warehouse,
                text: 'Rent',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerRent(),),);
                },
              ),
              GButton(
                icon: Icons.task,
                text: 'Task',
              ),
              GButton(
                icon: Icons.question_answer,
                text: 'Inquiry',
                onPressed: () {

                },
              ),
            ],
          ),
        ),
      ),
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
        title: const Text('Owner Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh,),
            color: Colors.white,
            tooltip: 'Refresh',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerTask(),),);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_task,),
            color: Colors.white,
            tooltip: 'Add Icon',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerAddTask(),),);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getTaskIDs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _tIDs.length,
                        itemBuilder: (context, index){
                          return OwnerTasksWidget(tasksID: _tIDs[index],);
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