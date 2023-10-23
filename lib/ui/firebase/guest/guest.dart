import 'dart:core';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/users-tab.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/userManagement/usersUtils.dart';
import '../../../backend/users/users.dart';
import '../../widgets/navigate-to-tab-button.dart';


class GuestTab extends StatelessWidget {
  const GuestTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar:AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            actions: [
              //Sign-out button
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  signOut(context);
                },
              ),
            ], //for hiding the shadows
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                const SizedBox(height: 10,),
                //Getting user info
                FutureBuilder(
                  future: readUser(getCurrentUserId()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){return Text(snapshot.error.toString());}
                    else if(snapshot.hasData) {
                      final dynamic user = snapshot.data!;
                      return coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user));
                    }
                    else{return const Center(child: CircularProgressIndicator());}
                  },
                ),
                const SizedBox(height: 10,),
                coloredArabicText("سيتم إضافتك لمجموعة قريباً"),
                const Expanded(flex:2,child: SizedBox()),
              ],
            ),
          )
      ),
    );
  }
  signOut(BuildContext context) {
    FirebaseAuth.instance.signOut()
        .then((value) => Navigator.pop(context, const Home()))
        .then((value) {showSnackBar(context, "لقد تم تسجيل الخروج بنجاح!");});
  }
  String getUserFirstName(FirebaseUser user) => user.firstName;
}