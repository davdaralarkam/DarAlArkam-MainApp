import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/backend/counter/getCounter.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:daralarkam_main_app/backend/users/supervisor.dart';
import 'package:daralarkam_main_app/ui/firebase/classReport/classReportWrite.dart';
import 'package:daralarkam_main_app/ui/firebase/classReport/classReportsViewer.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/addStudentsToClass.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/showClassStudents.dart';
import 'package:daralarkam_main_app/ui/firebase/users/admin/classrooms/selectATeacher.dart';
import 'package:daralarkam_main_app/ui/firebase/users/admin/classrooms/teacherProfile.dart';
import 'package:flutter/material.dart';

import '../../../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../../../backend/users/firebaseUser.dart';
import '../../../../widgets/navigate-to-tab-button.dart';
import '../../../../widgets/text.dart';

// A Flutter widget for displaying the classroom profile for admin.
class ClassroomProfileForAdminTab extends StatefulWidget {
  const ClassroomProfileForAdminTab({Key? key, required this.cid}) : super(key: key);

  // The classroom's unique identifier.
  final String cid;

  @override
  State<ClassroomProfileForAdminTab> createState() => _ClassroomProfileForAdminTabState();
}

class _ClassroomProfileForAdminTabState extends State<ClassroomProfileForAdminTab> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                }
                , icon: const Icon(Icons.refresh)
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10,),
              SizedBox(height: height * 0.1, child: Image.asset("lib/assets/photos/logo.png"),),
              const SizedBox(height: 10,),
              // Getting user info
              FutureBuilder(
                future: ClassroomMethods(widget.cid).fetchClassroomFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final Classroom classroom = snapshot.data! as Classroom;
                    return Column(
                      children: [
                        coloredArabicText("مجموعة " + getClassroomTitle(classroom)),
                        const SizedBox(height: 10,),
                        coloredArabicText('الصف: ${classroom.grade}'),
                        const SizedBox(height: 10,),
                        coloredArabicText('عدد الطلاب: ${classroom.studentIds.length}'),
                        const SizedBox(height: 10,),
                        FutureBuilder(
                          future: FirebaseUserMethods(classroom.teacherId).fetchUserFromFirestore(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('');
                            } else if (snapshot.hasData) {
                              final FirebaseUser user = snapshot.data! as FirebaseUser;
                              return TextButton(
                                  onPressed: () {
                                    // Navigation button to "Teacher's Profile" tab
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=> TeacherProfileTab(uid: user.id)));
                                  },
                                  child: coloredArabicText('المربي: ' + user.userName)
                                  );
                            } else {
                              return Text("");
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Expanded(child: SizedBox()),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10,),
                        navigationButtonFul(context, "الطلاب", ShowClassStudentsTab(classId: widget.cid,)),
                        const SizedBox(height: 10,),
                        navigationButtonFul(context, "اضافة طالب", AddStudentsToClassroomTab(classId: widget.cid,)),
                        const SizedBox(height: 10,),
                        navigationButtonFul(context, "تعيين مربي", SelectATeacherTab(classId: widget.cid))
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10,),
                        navigationButtonFul(context, "التقارير", ClassReportsViewerTab(classId: widget.cid)),
                        const SizedBox(height: 10,),
                        navigationButtonFul(context, "اضافة تقرير", ClassReportWriteTab(classId: widget.cid, date: getFormattedDate(), )),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

// A function to get the classroom title.
String getClassroomTitle(Classroom c) => c.title;
