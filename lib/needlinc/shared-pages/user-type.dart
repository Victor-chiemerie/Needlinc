import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/BizNameAndExp.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/EnterApp.dart';
import 'auth-pages/Occupation.dart';
import 'client-business-page-route.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    if (snapshot.data?['userCategory'] == 'User' ||
                        snapshot.data?['userCategory'] == 'Blogger') {
                      return ClientBusinessPageRoute(userCategory: snapshot.data?['userCategory']);
                    }
                    else if (snapshot.data?['userCategory'] == 'Business') {

                      return snapshot.data?['businessName'] == '' ?
                      BizNameAndExp()
                          :
                      ClientBusinessPageRoute(userCategory: snapshot.data?['userCategory']);
                    }
                    else if (snapshot.data?['userCategory'] == 'Freelancer') {

                     return snapshot.data?['skillSet'] == '' ?
                      Occupation()
                          :
                     ClientBusinessPageRoute(userCategory: snapshot.data?['userCategory']);

                    }
                    else if (snapshot.data?['userCategory'] == '') {
                      return const CategoryPage();
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } catch (error) {
                Center(
                  child: Text('$error'),
                );
              }
              return const Center(child: Text("Something went wrong..."));
            }));
  }
}
