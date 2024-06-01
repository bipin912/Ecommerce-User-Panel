
import 'package:e_com/controllers/google-sign-in-controller.dart';
import 'package:e_com/screens/auth-ui/sign-in-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({Key? key}) : super(key: key);

  final GoogleSignInController _googleSignInController =
  Get.put(GoogleSignInController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppConstant.appMainColor,
      title: Text("Welcome to my app",
      style: TextStyle(color: AppConstant.appTextColor),
      ),
    ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Color(0xFFF8F5F5),

          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Lottie.asset('assets/images/splash-icon.json'),),
              Container(
                margin: EdgeInsets.only(top: 20.0) ,
                  child: Text("Happy Shopping", style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  )
              ),
              SizedBox(
                height: Get.height / 12,
              ),
              Material(
                child: Container(

                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0)
                  ),

                  child: TextButton.icon(
                    icon: Image.asset('assets/images/google-logo.png', width: Get.width /12,
                    height: Get.height / 12,),
                    label: Text('Sign in with Google',
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                    ),),
                    onPressed: (){
                      _googleSignInController.signInWithGoogle();
                    },

                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 40,
              ),

              Material(
                child: Container(

                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),

                  ),

                  child: TextButton.icon(
                    icon: Icon(
                      Icons.email,
                    color : AppConstant.appTextColor,
                    ),
                    label: Text('Sign in with email',
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      ),),
                    onPressed: ()=> Get.to(()=>SignInScreen()),


                  ),
                ),
              ),



            ],
          ),
        ),
      ),

    );
  }
}
