import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/additionalInformation.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/searchAStudent.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../backend/classroom/classroomUtils.dart';
import '../../../backend/userManagement/additionalInformationMethods.dart';
import '../../../backend/users/student.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class AddStudentsToClassroomTab extends StatefulWidget {
  const AddStudentsToClassroomTab({Key? key,required this.classId}) : super(key: key);
  final String classId;

  @override
  State<AddStudentsToClassroomTab> createState() => _AddStudentsToClassroomTabState();
}

class _AddStudentsToClassroomTabState extends State<AddStudentsToClassroomTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store students data
  List<Student> students = [];

  // Stream to read students who are not in any classroom
  Stream<List<Student>> readStudentsOutsideAClassroom(String classId) =>
      FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'student')
          .where('classId', isEqualTo: "")
          .snapshots()
          .map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());

  // Function to sort students based on their first names
  void sortStudents(SortOrder order) {
    if (order == SortOrder.ascending) {
        students.sort((a, b) => a.fullName.compareTo(b.fullName));
      } else {
        students.sort((a, b) => b.fullName.compareTo(a.fullName));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("أضف طلاب لمجموعتك"),
          actions: [
            // Navigation button to "Search a Student" tab
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>
                          SearchAStudent(classId: widget.classId)));
                  },
                icon: const Icon(Icons.search_sharp)
            ),

            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortStudents(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readStudentsOutsideAClassroom(widget.classId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                students = snapshot.data as List<Student>;
                sortStudents(_currentSortOrder);
                return Center(
                  child: ListView(
                    children: students.map(buildStudent).toList(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildStudent(Student student) => ListTile(
    title: Text(student.fullName),
    subtitle: FutureBuilder(
      future: AdditionalInformationMethods(student.id).fetchInfoFromFirestore(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        else if(snapshot.hasData){
          final info = snapshot.data! as AdditionalInformation;
          return Text(info.groupName + " - " + info.teacherName + " - " + student.birthday);
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          return Text("يتم التحميل...");
        }
        else {
          return Text("لا توجد معلومات إضافية - " + student.birthday);
        }
      },
    ),
    trailing: ElevatedButton(
      onPressed: () {
        ClassroomMethods(widget.classId).addStudentToClass(context, student.id);
      },
      child: coloredArabicText("أضف",c: Colors.white),
    ),
  );



}
