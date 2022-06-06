import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter/material.dart';
import 'package:pickandgo/screens/loginpage.dart';

import 'models/model.dart';

class DatabaseHelper {
  //insert a recipe

  //update a recipe

  //delete Recipe Method
  deletemethod(String id) {
    final docUser = FirebaseFirestore.instance.collection('recipe').doc(id);
    //delete the recipe matching the id
    docUser.delete();
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await u.FirebaseAuth.instance.signOut();
    print("Signed out Successfully");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  //readRecipes method
  Stream<List<UserModel>> readCustomers() => FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: "User")
      //to get all the documents from the firebase connection
      //returns true snapshot of map string dynamic so we get sm json data bak
      .snapshots()
      //convert json data to user objects
      .map((snapshot) =>
          //going over all snapshot documents
          snapshot.docs.map((doc) =>
              //and convert each document back to user objects
              UserModel.fromJson(doc.data())).toList());
}
