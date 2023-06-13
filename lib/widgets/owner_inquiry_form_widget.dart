import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerInquiryFormWidget extends StatefulWidget {
  final String inquiryID, date, email, name, phone, comments;

  const OwnerInquiryFormWidget({super.key, required this.inquiryID, required this.date, required this.email, required this.name, required this.phone, required this.comments});

  @override
  State<OwnerInquiryFormWidget> createState() => _OwnerInquiryFormWidgetState();
}

class _OwnerInquiryFormWidgetState extends State<OwnerInquiryFormWidget> {
  final _replyKey = GlobalKey<FormState>();
  final User? user = FirebaseAuth.instance.currentUser;
  bool replyButton = false;
  TextEditingController replyController = TextEditingController();

  openEmail(BuildContext context) async{
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'esoonbojio@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Inquiry Form for ${widget.name}',
        'body': replyController.text.toString(),
      }),
    );

    if(await canLaunchUrl(emailLaunchUri)){
      await launchUrl(emailLaunchUri);
      deleteReplyMessage();
    }else{
      throw Exception('Could not launch $emailLaunchUri');
    }
  }


  @override
  void dispose(){
    //To solve the bug from triggering dispose method when closing the alert dialog.
    if(replyButton) {
      replyController.dispose();
      print("asdasd");
      print(replyButton);
    }
    super.dispose();
  }

  deleteReplyMessage() async{
    await FirebaseFirestore.instance
        .collection("OwnerProperty")
        .doc(user?.uid.toString())
        .collection("InquiryFormProperty")
        .doc(widget.inquiryID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${widget.name}"),
                        Text("Email: ${widget.email}"),
                        Text("Phone: ${widget.phone}"),
                        Text("Comments: ${widget.comments}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async{
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Reply"),
                                  content: SingleChildScrollView(
                                    child:ListBody(
                                      children: <Widget>[
                                        Form(
                                          key: _replyKey,
                                          child: TextFormField(
                                            controller: replyController,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter something before you reply!';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 10,

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Send'),
                                      onPressed: () async {
                                        if (_replyKey.currentState!.validate()) {
                                          replyButton = true;
                                          openEmail(context);
                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text("Reply")
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
