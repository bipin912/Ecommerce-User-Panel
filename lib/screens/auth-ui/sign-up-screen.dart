import 'package:e_com/controllers/sign-up-controller.dart';
import 'package:e_com/screens/auth-ui/sign-in-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            centerTitle: true,
            title: Text(
              "Sign Up",
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "Welcome to my app",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
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
                      child: TextFormField(
                        controller: userName,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person),
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
                      child: TextFormField(
                        controller: userPhone,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "Phone",
                            prefixIcon: Icon(Icons.phone),
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
                      child: TextFormField(
                        controller: userCity,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            hintText: "City",
                            prefixIcon: Icon(Icons.location_city),
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
                                signUpController.isPasswordVisible.value,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signUpController.isPasswordVisible
                                          .toggle();
                                    },
                                    child:
                                        signUpController.isPasswordVisible.value
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                contentPadding:
                                    EdgeInsets.only(top: 2.0, left: 8.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        )),
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
                          'SIGN UP',
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                          ),
                        ),
                        onPressed: () async {
                          String name = userName.text.trim();
                          String email = userEmail.text.trim();
                          String phone = userPhone.text.trim();
                          String city = userCity.text.trim();
                          String password = userPassword.text.trim();


                          if (name.isEmpty ||
                              email.isEmpty ||
                              phone.isEmpty ||
                              city.isEmpty ||
                              password.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please enter all details",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor,
                            );
                          } else {
                            UserCredential? userCredential =
                                await signUpController.signUpMethod(name, email,
                                    phone, city, password, );

                            if(userCredential != null){
                              Get.snackbar(
                                "Verification email sent.",
                                "Please check your email.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );

                              FirebaseAuth.instance.signOut();
                              Get.offAll(()=> SignInScreen());


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
                        "Already have an account?  ",
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 20,
                      ),
                      GestureDetector(
                        onTap: () => Get.offAll(() => SignInScreen()),
                        child: Text(
                          "Sign In",
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
