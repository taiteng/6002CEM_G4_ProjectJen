import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyFormWidget extends StatefulWidget {
  final String id, name, salesType;
  final int price;

  const PropertyFormWidget(
      {super.key,
      required this.id,
      required this.name,
      required this.salesType,
      required this.price});

  @override
  State<PropertyFormWidget> createState() => _PropertyFormWidgetState();
}

class _PropertyFormWidgetState extends State<PropertyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late bool validEmail = true;
  final User? user = FirebaseAuth.instance.currentUser;

  static const formSnackBar = SnackBar(
    content: Text('Form Submitted!'),
  );

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    commentsController.dispose();
    super.dispose();
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
      "pID": widget.id.toString(),
      "Name": nameController.text,
      "Email": emailController.text,
      "Phone": phoneController.text.toString(),
      "Comments": "I have some question or doubt about the ${widget.name} "
          "which is currently for ${widget.salesType} in RM${widget.price}. ${commentsController.text}",
      'Date': currentDate.toString(),
    });

    nameController.clear();
    phoneController.clear();
    emailController.clear();
    commentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Inquiry Form",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                          RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value);

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
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
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
      ],
    );
  }
}
