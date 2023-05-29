import 'dart:io';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectjen/pages/owner_home.dart';
import 'package:projectjen/widgets/property_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OwnerEditProperty extends StatefulWidget {

  final String propertyID, name, address, amenities, category, facilities, image, date, state, salesType;
  final int price, lotSize, numOfVisits;

  const OwnerEditProperty({Key? key,
    required this.propertyID,
    required this.name,
    required this.address,
    required this.amenities,
    required this.category,
    required this.facilities,
    required this.image,
    required this.date,
    required this.state,
    required this.salesType,
    required this.price,
    required this.lotSize,
    required this.numOfVisits,
  }) : super(key: key);
  @override
  State<OwnerEditProperty> createState() => _OwnerEditPropertyState();
}

class _OwnerEditPropertyState extends State<OwnerEditProperty> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController lotSizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amenityController = TextEditingController();
  TextEditingController facilityController = TextEditingController();

  String? categoryValue, salesTypeValue, stateValue;

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
    final path = 'PropertyImages/${_pickedFile!.name}';
    final file = File(_pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      _uploadTask = ref.putFile(file);
    });

    final snapshot = await _uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();
    //print('Download URL: $urlDownload');

    setState(() {
      _uploadTask = null;
    });
  }

  Future uploadToFirebase() async{
    try{
      String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

      if(_pickedFile == null){
        await FirebaseFirestore.instance.collection('Property').doc(widget.propertyID.toString()).set({
          'Name' : nameController.text,
          'LotSize' : int.parse(lotSizeController.text),
          'Price' : int.parse(priceController.text),
          'Address' : addressController.text,
          'Amenities' : amenityController.text,
          'Facilities' : facilityController.text,
          'Image' : widget.image.toString(),
          'Category' : categoryValue.toString(),
          'SalesType' : salesTypeValue.toString(),
          'State' : stateValue.toString(),
          'NumOfVisits' : widget.numOfVisits,
          'Date' : widget.date.toString(),
          'PropertyID' : widget.propertyID.toString(),
        });

        await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').doc(widget.propertyID.toString()).set({
          'pID' : widget.propertyID.toString(),
          'SalesType' : salesTypeValue.toString(),
        });
      }
      else{
        await uploadFile();

        await FirebaseFirestore.instance.collection('Property').doc(widget.propertyID.toString()).set({
          'Name' : nameController.text,
          'LotSize' : int.parse(lotSizeController.text),
          'Price' : int.parse(priceController.text),
          'Address' : addressController.text,
          'Amenities' : amenityController.text,
          'Facilities' : facilityController.text,
          'Image' : urlDownload.toString(),
          'Category' : categoryValue.toString(),
          'SalesType' : salesTypeValue.toString(),
          'State' : stateValue.toString(),
          'NumOfVisits' : widget.numOfVisits,
          'Date' : widget.date.toString(),
          'PropertyID' : widget.propertyID.toString(),
        });

        await FirebaseFirestore.instance.collection('OwnerProperty').doc(user?.uid.toString()).collection('OwnerPropertyIDs').doc(widget.propertyID.toString()).set({
          'pID' : widget.propertyID.toString(),
          'SalesType' : salesTypeValue.toString(),
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OwnerHome()));
      });
    } catch (e){
      print(e);
    }
  }

  @override
  void dispose(){
    nameController.dispose();
    lotSizeController.dispose();
    priceController.dispose();
    addressController.dispose();
    amenityController.dispose();
    facilityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = new TextEditingController(text: widget.name.toString());
    lotSizeController = new TextEditingController(text: widget.lotSize.toString());
    priceController = new TextEditingController(text: widget.price.toString());
    addressController = new TextEditingController(text: widget.address.toString());
    amenityController = new TextEditingController(text: widget.amenities.toString());
    facilityController = new TextEditingController(text: widget.facilities.toString());
    categoryValue = widget.category.toString();
    salesTypeValue = widget.salesType.toString();
    stateValue = widget.state.toString();
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
        title: const Text('Edit Property'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerHome(),),);
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              PropertyTextField(
                controller: nameController,
                hintText: 'Name',
              ),
              SizedBox(height: 10,),
              PropertyTextField(
                controller: lotSizeController,
                hintText: 'Lot Size (Square Feet)',
              ),
              SizedBox(height: 10,),
              Padding(
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
                    value: categoryValue,
                    isExpanded: true,
                    hint: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Choose Category'),
                    ),
                    items: ['Villa', 'Shop', 'Condo', 'Apartment', 'Studio', 'Bangalow', 'Castle', 'Others',].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        categoryValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
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
                    value: salesTypeValue,
                    isExpanded: true,
                    hint: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Type of Sale'),
                    ),
                    items: ['Rent', 'Sell',].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        salesTypeValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10,),
              PropertyTextField(
                controller: amenityController,
                hintText: 'Amenities (Specify Number)',
              ),
              SizedBox(height: 10,),
              PropertyTextField(
                controller: facilityController,
                hintText: 'Facilities',
              ),
              SizedBox(height: 10,),
              PropertyTextField(
                controller: priceController,
                hintText: 'Price (RM)',
              ),
              SizedBox(height: 10,),
              PropertyTextField(
                controller: addressController,
                hintText: 'Address',
              ),
              SizedBox(height: 10,),
              Padding(
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
                    value: stateValue,
                    isExpanded: true,
                    hint: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('State'),
                    ),
                    items: ['Perlis', 'Kedah', 'Penang', 'Perak', 'Selangor', 'Negeri Sembilan', 'Malacca', 'Johor', 'Kelantan', 'Terengganu', 'Pahang', 'Kuala Lumpur', 'Putrajaya',].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        stateValue = newValue!;
                      });
                    },
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SlideAction(
                  onSubmit: (){
                    uploadToFirebase();
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
              SizedBox(height: 10,),
              buildProgress(),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
