import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../../services/utils/showSnackBar.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class AddStudentsToClassroomTab extends StatefulWidget {
  const AddStudentsToClassroomTab({Key? key,required this.classId}) : super(key: key);
  final classId;

  @override
  State<AddStudentsToClassroomTab> createState() => _AddStudentsToClassroomTabState();
}

class _AddStudentsToClassroomTabState extends State<AddStudentsToClassroomTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store students data
  List<Student> students = [];

  // Stream to read students who are not in any classroom
  Stream<List<FirebaseUser>> readStudentsOutsideAClassroom(String classId) =>
      FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'student')
          .where('classId', isEqualTo: "")
          .snapshots()
          .map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());

  // Function to sort students based on their first names
  void sortStudents(SortOrder order) {
    if (order == SortOrder.ascending) {
        students.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        students.sort((a, b) => b.firstName.compareTo(a.firstName));
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

  // Build a list tile for a student
  Widget buildStudent(Student student) => ListTile(
    title: Text(student.firstName + " " + student.secondName + " " + student.thirdName),
    subtitle: Text(student.birthday),
    trailing: ElevatedButton(
      onPressed: () {
        addStudentToClass(widget.classId, student.id);
        // setState(() {});
      },
      child: coloredArabicText("أضف",c: Colors.white),
    ),
  );

  // Function to add a student to a classroom
  Future<void> addStudentToClass(String classId, String studentId) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(studentId);
    await docUser.update({"classId": classId}).then((value) {
      final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
      docClass.update({
        'studentIds': FieldValue.arrayUnion([studentId]),
      }).then((_) {
        showSnackBar(context, "تمت إضافة الطالب بنجاح");
      }).catchError((error) {
        showSnackBar(context, "حدث خطأ أثناء إضافة الطالب: $error");
      });
    }).catchError((error) {
      showSnackBar(context, "حدث خطأ أثناء تحديث معلومات الطالب: $error");
    });
  }
}