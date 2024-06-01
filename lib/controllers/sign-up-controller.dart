import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/models/user_model.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'get-device-token-controller.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,

  ) async {
    final GetDeviceTokenController getDeviceTokenController =
    Get.put(GetDeviceTokenController());

    try {

      EasyLoading.show(status: "Please await");

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      //send email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now(),
          city: userCity);

      //add data to firestore
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
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
