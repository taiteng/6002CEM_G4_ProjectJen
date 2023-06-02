import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projectjen/widgets/review_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hidden_drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyDetail extends StatefulWidget {
  final String imageURL,
      name,
      address,
      date,
      id,
      category,
      facilities,
      contact,
      state,
      salesType,
      amenities;
  final int price, lotSize, numOfVisits, beds, bathrooms;

  const PropertyDetail({
    Key? key,
    required this.imageURL,
    required this.name,
    required this.address,
    required this.date,
    required this.id,
    required this.category,
    required this.facilities,
    required this.contact,
    required this.salesType,
    required this.amenities,
    required this.price,
    required this.lotSize,
    required this.beds,
    required this.bathrooms,
    required this.state,
    required this.numOfVisits,
  }) : super(key: key);

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  bool isFavourite = false;
  final _formKey = GlobalKey<FormState>();
  late bool validEmail = true;
  final User? user = FirebaseAuth.instance.currentUser;
  static const formSnackBar = SnackBar(
    content: Text('Form Submitted!'),
  );
  static const invalidEmailSnackBar = SnackBar(
    content: Text('Please provide a valid email address'),
  );

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    checkFavouriteProperty();
    getReviews();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    emailController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getReviews() async* {
    //1. Get documents from "Reviews"
    final Stream<QuerySnapshot> reviews = FirebaseFirestore.instance
        .collection('Reviews')
        .doc(widget.id.toString())
        .collection('UserReviews')
        .snapshots();

    //2. Get the data and return to stream"
    yield* reviews;
    setState(() {});
  }

  void launchWhatsApp(String phone, String message) {
    final Uri whatsApp = Uri.parse("https://wa.me/6$phone?text=$message");
    launchUrl(
      whatsApp,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  void inquiryFormSubmission() async {
    String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    final ownerID = await FirebaseFirestore.instance
        .collection("Property")
        .doc(widget.id.toString())
        .get()
        .then((snapshot) => snapshot.get("OID"));

    await FirebaseFirestore.instance
        .collection("OwnerProperty")
        .doc(ownerID)
        .collection("InquiryFormProperty")
        .doc(widget.id.toString())
        .set({
      "uID": user?.uid.toString(),
      "Name": nameController.text,
      "Email": emailController.text,
      "Phone": phoneController.text.toString(),
      "Comments": commentsController.text,
      'Date': currentDate.toString(),
    });

    nameController.clear();
    phoneController.clear();
    emailController.clear();
    commentsController.clear();
  }

  // Check if the current propertyID exists in Firestore
  Future<void> checkFavouriteProperty() async {
    final propertyIDSnapshot = await FirebaseFirestore.instance
        .collection('Favourite')
        .doc(user?.uid.toString())
        .collection('FavouriteProperty')
        .doc(widget.id)
        .get();

    setState(() {
      isFavourite =
          propertyIDSnapshot.exists; //return true if exist, else false
    });
  }

  // Toggle the favourite status of the property
  Future<void> operationFavouriteProperty() async {
    final favouriteRef = FirebaseFirestore.instance
        .collection("Favourite")
        .doc(user?.uid.toString())
        .collection("FavouriteProperty")
        .doc(widget.id);

    if (isFavourite) {
      await favouriteRef.delete();
    } else {
      await favouriteRef.set({'PID': widget.id});
    }

    setState(() {
      isFavourite = !isFavourite;
    });
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
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HiddenDrawer(pageNum: 0),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.white,
              ),
              child: IconButton(
                icon:
                    isFavourite //If database got the property, return the favourite else not favourite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                onPressed: () {
                  operationFavouriteProperty();
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String message =
                  "${widget.imageURL}\nHi, I am interested in ${widget.name} which is for ${widget.salesType} at RM${widget.price}.";
              launchWhatsApp("0143096966", message);
            },
            child: IgnorePointer(
              child: SizedBox(
                height: 60,
                width: 250,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Contact Me"),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/images/whatsapp.png",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          child: widget.salesType == "Rent"
                              ? Text(
                                  "RM${widget.price}/month",
                                  style: const TextStyle(fontSize: 12),
                                )
                              : Text(
                                  "RM${widget.price}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bed,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.beds.toString()} Beds",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bathtub,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.bathrooms.toString()} Bathrooms",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 35,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.landscape,
                                size: 15,
                              ),
                              Text(
                                "  ${widget.lotSize} Sqft",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.salesType} Details",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Amenities: ${widget.amenities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "LotSize: ${widget.lotSize}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Category: ${widget.category}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Facilities: ${widget.facilities}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Feel free to contact me at ${widget.contact} for more information!",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Inquiry Form",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile phone number';
                              } else if (value.isNotEmpty) {
                                bool phoneValid =
                                    RegExp(r'(^(?:[+0]9)?[0-9]{10}$)')
                                        .hasMatch(value);

                                if (phoneValid) {
                                  validEmail = true;
                                  return null;
                                } else {
                                  validEmail = false;
                                  return "Please provide a valid phone number";
                                }
                              }
                              return null;
                            },
                            //controller: ,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: "Mobile Phone",
                              hintStyle: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            } else if (value.isNotEmpty) {
                              bool emailValid = RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value);

                              if (emailValid) {
                                validEmail = true;
                                return null;
                              } else {
                                validEmail = false;
                                return "Please provide a valid email address";
                              }
                            }
                            return null;
                          },
                          //controller: ,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            contentPadding: const EdgeInsets.all(10.0),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: commentsController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your question!';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          //controller: ,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            contentPadding: const EdgeInsets.all(10.0),
                            hintText: "Comments",
                            hintStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  inquiryFormSubmission();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(formSnackBar);
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: getReviews(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }else if(snapshot.connectionState == ConnectionState.active){
                            return ListView(
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                                return ReviewCard(
                                  pid: widget.id.toString(),
                                  name: data['Name'],
                                  rating: data['Rating'],
                                  comment: data['Comment'],
                                );
                              }).toList(),
                            );
                          }else{
                            return Text("ADSAD");
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
