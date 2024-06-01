import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/screens/auth-ui/sign-in-screen.dart';

import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<void> ForgetPasswordMethod(

      String userEmail,
      ) async {
    try {

      EasyLoading.show(status: "Please await");

      await _auth.sendPasswordResetEmail(email: userEmail);

      Get.snackbar(
        "Request sent successfully",
        "Password reset link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,

      );

      Get.offAll(()=> SignInScreen());






      EasyLoading.dismiss();


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
