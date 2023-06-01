import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:projectjen/pages/hidden_drawer_menu.dart';
import 'package:projectjen/widgets/property_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEditProfile extends StatefulWidget {

  final String profilePic, username, email, loginMethod, phone, role, uID;

  const UserEditProfile({
    Key? key,
    required this.profilePic,
    required this.username,
    required this.email,
    required this.loginMethod,
    required this.phone,
    required this.role,
    required this.uID,
  }) : super(key: key);

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  String? urlDownload;

  final User? user = FirebaseAuth.instance.currentUser;

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      _pickedFile = result.files.first;
    });
  }

  Future uploadFile() async{
    final path = 'UserProfile/${_pickedFile!.name}';
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

  Future uploadToFirebase() async{
    try{
      if(_pickedFile == null){
        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'LoginMethod' : widget.loginMethod.toString(),
          'Phone' : phoneController.text,
          'ProfilePic' : widget.profilePic.toString(),
          'Role' : widget.role.toString(),
          'UID' : widget.uID.toString(),
          'Username' : usernameController.text,
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
      }
      else{
        await uploadFile();

        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).set({
          'Email' : widget.email.toString(),
          'LoginMethod' : widget.loginMethod.toString(),
          'Phone' : phoneController.text,
          'ProfilePic' : urlDownload.toString(),
          'Role' : widget.role.toString(),
          'UID' : widget.uID.toString(),
          'Username' : usernameController.text,
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {

      });
    } catch (e){
      print(e);
    }
  }

  @override
  void dispose(){
    usernameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameController = new TextEditingController(text: widget.username.toString());
    phoneController = new TextEditingController(text: widget.phone.toString());
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: _uploadTask?.snapshotEvents,
    builder: (context, snapshot){
      if(snapshot.hasData){
        final data = snapshot.data!;
        double progress = data.bytesTransferred / data.totalBytes;

        return SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.deepOrangeAccent,
              ),
              Center(
                child: Text(
                  '${(100 * progress).round()}%',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if(snapshot.connectionState ==  ConnectionState.waiting){
        return Text('Waiting for Upload');
      }
      else{
        return Text('');
      }
    },
  );

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
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer(pageNum: 2),),);
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
                PropertyTextFormField(
                  controller: usernameController,
                  hintText: 'Username',
                  emptyText: 'Please enter username',
                ),
                SizedBox(height: 10,),
                PropertyTextFormField(
                  controller: phoneController,
                  hintText: 'Phone',
                  emptyText: 'Please enter phone number',
                ),
                SizedBox(height: 10,),
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
                SizedBox(height: 10,),
                _pickedFile != null
                    ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.file(
                    File(_pickedFile!.path!),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  ),
                )
                    : Text(
                  "(No Image Received)",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      uploadToFirebase();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "SUBMIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                buildProgress(),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
