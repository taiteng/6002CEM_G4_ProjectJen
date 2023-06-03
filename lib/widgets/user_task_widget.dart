import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';

class UserTasksWidget extends StatefulWidget {

  final String taskID;

  UserTasksWidget({Key? key, required this.taskID}) : super(key: key);

  @override
  State<UserTasksWidget> createState() => _UserTasksWidgetState();
}

class _UserTasksWidgetState extends State<UserTasksWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  String? Status;
  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  String? urlDownload;
  String? DocID;
  String? UName;

  Future<String?> fetchTaskCompletionStatus() async {
    final taskCompSnapshot = await FirebaseFirestore.instance
        .collection('TaskCompletion')
        .where('tID', isEqualTo: widget.taskID)
        .get();

    if (taskCompSnapshot.docs.isNotEmpty) {
      return taskCompSnapshot.docs.first.get('Status') as String?;
    } else {
      return null;
    }
  }

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      _pickedFile = result.files.first;
    });
  }

  Future uploadFile() async{
    final path = 'TaskImages/${_pickedFile!.name}';
    final file = File(_pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      _uploadTask = ref.putFile(file);
    });

    final snapshot = await _uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _uploadTask = null;
    });
  }

  Future getUsername() async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString());
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      UName = data['Username'];
    } else {
      print('Username does not exist.');
    }
  }

  Future uploadToFirebase() async{
    try{
      await uploadFile();
      await getUsername();

      String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

      await FirebaseFirestore.instance.collection('TaskCompletion').add({
        'ImageURL' : urlDownload.toString(),
        'uID' : user?.uid.toString(),
        'uName' : UName.toString(),
        'DateOfCompletion' : currentDate.toString(),
        'Status' : 'Completed',
        'tID' : widget.taskID,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 3),),);
    } catch (e){
      print(e);
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Image'),
          content: Column(
            children: [
              GestureDetector(
                onTap: (){
                  selectFile();
                },
                child: Container(
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              _pickedFile != null
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: Image.file(
                  File(_pickedFile!.path!),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              ) : const Text(
                "(No Image Received)",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                uploadToFirebase();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    fetchTaskCompletionStatus();
    CollectionReference _tasks = FirebaseFirestore.instance.collection('Task');

    return FutureBuilder<DocumentSnapshot>(
      future: _tasks.doc(widget.taskID).get(),
      builder: ((context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 140,
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
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
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
                          const SizedBox(width: 5,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FutureBuilder<String?>(
                            future: fetchTaskCompletionStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text(snapshot.error.toString()));
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                Status = snapshot.data!;

                                return ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    Status.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                );
                              } else {
                                return ElevatedButton(
                                  onPressed: () {
                                    _showDialog();
                                  },
                                  child: const Text(
                                    'Incomplete',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
