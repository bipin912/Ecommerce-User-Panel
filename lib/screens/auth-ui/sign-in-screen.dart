import 'package:e_com/controllers/get-user-data-controller.dart';
import 'package:e_com/controllers/sign-in-controller.dart';
import 'package:e_com/screens/admin-panel/admin-main-screen.dart';
import 'package:e_com/screens/auth-ui/forget-password-screen.dart';
import 'package:e_com/screens/auth-ui/sign-up-screen.dart';
import 'package:e_com/screens/user-panel/main-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataCOntroller getUserDataCOntroller =
      Get.put(GetUserDataCOntroller());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            centerTitle: true,
            title: Text(
              "Sign In",
              style: TextStyle(color: AppConstant.appTextColor),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isKeyboardVisible
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "Welcome to my app",
                            style: TextStyle(
                                color: AppConstant.appSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: Get.height / 20,
                            ),
                            Lottie.asset('assets/images/splash-icon.json')
                          ],
                        ),
                  SizedBox(
                    height: Get.height / 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            obscureText:
                                signInController.isPasswordVisible.value,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signInController.isPasswordVisible
                                          .toggle();
                                    },
                                    child:
                                        signInController.isPasswordVisible.value
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                contentPadding:
                                    EdgeInsets.only(top: 2.0, left: 8.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ForgetPasswordScreen());
                      },
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height / 20,
                  ),
                  Material(
                    child: Container(
                      width: Get.width / 2,
                      height: Get.height / 18,
                      decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                          ),
                        ),
                        onPressed: () async {
                          String email = userEmail.text.trim();
                          String password = userPassword.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            Get.snackbar("Error", "Please enter all details");
                          } else {
                            UserCredential? userCredential =
                                await signInController.signInMethod(
                                    email, password);

                            var userData = await getUserDataCOntroller
                                .getUserData(userCredential!.user!.uid);

                            if (userCredential != null) {
                              if (userCredential.user!.emailVerified) {
                                if (userData[0]['isAdmin'] == true) {
                                  Get.offAll(() => AdminMainScreen());
                                  Get.snackbar(
                                    "Success Admin Login",
                                    "Login Successfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                } else {
                                  Get.offAll(() => MainScreen());
                                  Get.snackbar(
                                    "Success User Login",
                                    "Login Successfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Please verify email before login",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor,
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please Try Again",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 20,
                      ),
                      GestureDetector(
                        onTap: () => Get.offAll(() => SignUpScreen()),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: AppConstant.appSecondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
