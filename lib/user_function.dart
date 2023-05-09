import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class getUserInfo {
  final User? user = FirebaseAuth.instance.currentUser;

  String? getUID() {
    final String? uid = user?.uid.toString();

    return uid;
  }

  String? getEmail() {
    final String? email = user?.email.toString();
    return email;
  }
}