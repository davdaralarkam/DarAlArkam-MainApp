import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/studentMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/teacherMethods.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../users/users.dart';

// Class to encapsulate Firebase user-related methods.
class FirebaseUserMethods {
  final String userId;

  FirebaseUserMethods(this.userId);

  // Fetches user information from Firestore.
  Future<FirebaseUser?> fetchUserFromFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return FirebaseUser.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Checks if a user with the given UID exists in Firestore.
  Future<bool> doesUserExistInFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return true;
    }
    return false;
  }

  // Retrieves the full name of the user.
  Future<String> getUsername() async {
    final user = await fetchUserFromFirestore();

    if (user != null) {
      return user.firstName + " " + user.secondName + " " + user.thirdName;
    }
    return '';
  }

  // Retrieves the user's type.
  Future<String> getType() async {
    final user = await fetchUserFromFirestore();

    if (user != null) {
      return user.type;
    }
    return '';
  }


  /// Converts a user to an admin role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "admin".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students and teachers).
  Future<void> castToGuest(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "admin":
              return; // If the user is already an admin, no action is required.

            case "student":
            // For students, remove them from their classroom before converting to admin.
              await StudentMethods(userId).removeStudentFromHisClassroom(context);
              break;

            case 'teacher':
            // For teachers, remove them from their classrooms before converting to admin.
              await TeacherMethods(userId).removeTeacherFromHisClassrooms(context);
              break;

            default:
              break;
          }

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "admin"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }


  /// Converts a user to an guest role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "guest".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students and teachers).
  Future<void> castToAdmin(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "guest":
              return; // If the user is already an admin, no action is required.

            case "student":
            // For students, remove them from their classroom before converting to admin.
              await StudentMethods(userId).removeStudentFromHisClassroom(context);
              break;

            case 'teacher':
            // For teachers, remove them from their classrooms before converting to admin.
              await TeacherMethods(userId).removeTeacherFromHisClassrooms(context);
              break;

            default:
              break;
          }

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "guest"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  /// Converts a user to an student role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "student".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (teachers),
  /// and adding a 'classId' field.
  Future<void> castToStudent(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "student":
              return; // If the user is already an admin, no action is required.

            case 'teacher':
            // For teachers, remove them from their classrooms before converting to admin.
              await TeacherMethods(userId).removeTeacherFromHisClassrooms(context);
              break;

            default:
              break;
          }

          // Add an empty 'classId' field to the user's document in Firebase
          await docUser.update({"classId": ""}).onError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "student"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  /// Converts a user to a teacher role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "teacher".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students),
  /// and adding a 'classIds' field with an empty list.
  Future<void> castToTeacher(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "teacher":
              return; // If the user is already an admin, no action is required.

            case "student":
            // For students, remove them from their classroom before converting to admin.
              await StudentMethods(userId).removeStudentFromHisClassroom(context);
              break;

            default:
              break;
          }

          // Add an empty 'classIds' field to the user's document in Firebase
          await docUser.update({"classIds": []}).onError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "guest"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  // Deletes the user from Firestore.
  Future<void> deleteUser(BuildContext context) async {
    final docUser =
    FirebaseFirestore.instance.collection('users').doc(userId);
    await docUser.delete();
    Navigator.pop(context);
  }
}