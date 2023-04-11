import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  ///sign in method.
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    //obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (firebaseUser.user != null) {
      return true;
    } else {
      return false;
    }
  }
}

final googleAuthProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) {
    return AuthProvider();
  },
);
