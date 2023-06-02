import 'package:projectjen/pages/owner/owner_task.dart';
import 'package:projectjen/widgets/task_text_form_field.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class OwnerEditTask extends StatefulWidget {

  final String taskID, title, desc, dueDate, pID, pName;

  const OwnerEditTask({
    Key? key,
    required this.taskID,
    required this.title,
    required this.desc,
    required this.dueDate,
    required this.pID,
    required this.pName,
  }) : super(key: key);

  @override
  State<OwnerEditTask> createState() => _OwnerEditTaskState();
}

class _OwnerEditTaskState extends State<OwnerEditTask> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  String? propertyValue;
  String? propertyID;
  String? propertyName;

  List<String> _propertyList = [];

  final User? user = FirebaseAuth.instance.currentUser;

  Future uploadToFirebase() async{
    try{
      await FirebaseFirestore.instance.collection('Property').where('Name', isEqualTo: propertyValue.toString()).get().then(
            (snapshot) => snapshot.docs.forEach((properties) {
          if (properties.exists) {
            propertyID = properties.reference.id;
          } else {
            print("Ntg to see here");
          }
        }),
      );

      await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('Tasks').doc(widget.taskID).set({
        'Title' : titleController.text,
        'Description' : descriptionController.text,
        'DueDate' : dueDateController.text,
        'pID' : propertyID.toString(),
        'pName' : propertyValue.toString(),
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerTask(),),);
    } catch (e){
      print(e);
    }
  }

  Future fetchOwnerProperty() async {
    final ownerPropertySnapshot = await FirebaseFirestore.instance
        .collection('OwnerProperty')
        .doc(user?.uid.toString())
        .collection('OwnerPropertyIDs')
        .get();

    for (final ownerProperties in ownerPropertySnapshot.docs) {
      if (ownerProperties.exists) {
        final propertySnapshot = await FirebaseFirestore.instance
            .collection('Property')
            .where('PropertyID', isEqualTo: ownerProperties.reference.id)
            .get();

        for (final pDoc in propertySnapshot.docs) {
          if (pDoc.exists) {
            _propertyList.add(pDoc['Name']);
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
  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    propertyValue = '';

    super.dispose();
  }

  @override
  void initState() {
    titleController = new TextEditingController(text: widget.title.toString());
    descriptionController = new TextEditingController(text: widget.desc.toString());
    dueDateController = new TextEditingController(text: widget.dueDate.toString());
    propertyValue = widget.pName.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: const Text('Edit Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerTask(),),);
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                TaskTextFormField(
                  controller: titleController,
                  hintText: 'Title',
                  emptyText: 'Please enter title',
                ),
                SizedBox(height: 10,),
                TaskTextFormField(
                  controller: descriptionController,
                  hintText: 'Description',
                  emptyText: 'Please enter description',
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose date';
                      }
                      return null;
                    },
                    controller: dueDateController,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dueDateController.text = formattedDate;
                        });
                      }
                      else {
                        dueDateController.text = 'Error';
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Due Date',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                FutureBuilder(
                    future: fetchOwnerProperty(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if (snapshot.connectionState == ConnectionState.done) {
                        if(snapshot.hasData){
                          _propertyList = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButton(
                                value: propertyValue,
                                isExpanded: true,
                                hint: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Choose Property'),
                                ),
                                items: _propertyList.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    propertyValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                        else{
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black45,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButton(
                                value: propertyValue,
                                isExpanded: true,
                                hint: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Choose Property'),
                                ),
                                items: _propertyList.toSet().map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    propertyValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      }
                      else {
                        return const Text("loading");
                      }
                    }
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SlideAction(
                    onSubmit: (){
                      if (_formKey.currentState!.validate()) {
                        uploadToFirebase();
                      }
                    },
                    borderRadius: 4,
                    innerColor: CupertinoColors.inactiveGray,
                    outerColor: CupertinoColors.white,
                    elevation: 1,
                    text: 'Slide to Submit',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    //sliderRotate: false,
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}