import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async{
    try{
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null) {
        return;
      }
      else{
        _user = googleUser;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'Email' : user!.email,
        'Phone' : user!.phoneNumber,
        'Username' : user!.displayName,
        'ProfilePic' : user!.photoURL,
        'Role' : 'Renter',
        'LoginMethod' : 'Google',
        'UID' : FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future googleLogout() async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}