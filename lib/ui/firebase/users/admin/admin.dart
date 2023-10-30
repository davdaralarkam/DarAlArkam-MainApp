import 'dart:core';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/users-tab.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/firebaseAuthMethods.dart';
import 'classrooms/classroom-tab-for-admin.dart';
import 'classrooms/createAClassroom.dart';
import '../../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../../backend/users/users.dart';
import '../../../widgets/navigate-to-tab-button.dart';

class AdminTab extends StatelessWidget {
  const AdminTab({super.key});


  // Function to get the user's first name
  String getUserFirstName(FirebaseUser user) => user.firstName;

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

            body: FutureBuilder(
              future: readUser(getCurrentUserId()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData){
                  final FirebaseUser user = snapshot.data! as FirebaseUser;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),

                        // Logo
                        SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                        const SizedBox(height: 10,),

                        //greeting message
                        coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user)),
                        const SizedBox(height: 10,),


                        //Admin functions
                        SingleChildScrollView(
                          child: Column(
                              children: [

                                //A button to navigate to the "Users Tab"
                                navigationButtonFul(context, "المستخدمين", UsersTab()),
                                const SizedBox(height: 10,),

                                //A button to navigate to the "Create A classroom tab"
                                navigationButtonFul(context, "انشئ مجموعة", CreateAClassroomTab()),
                                const SizedBox(height: 10,),

                                //A button to navigate to the "Classrooms Tab For Admin"
                                navigationButtonFul(context, "المجموعات", ClassroomsTabForAdmin()),
                              ]
                          ),
                        ),
                        const Expanded(flex:2,child: SizedBox()),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            )
        )
    );
  }
}
