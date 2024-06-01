import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/controllers/get-device-token-controller.dart';

import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signInMethod(

      String userEmail,
      String userPassword,

      ) async {
    try {

      EasyLoading.show(status: "Please await");

      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword,
      );





      EasyLoading.dismiss();
      return userCredential;

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,
      );
    }
  }
}
