import 'dart:async';

import 'package:e_com/controllers/get-user-data-controller.dart';
import 'package:e_com/screens/admin-panel/admin-main-screen.dart';
import 'package:e_com/screens/auth-ui/welcome-screen.dart';
import 'package:e_com/screens/user-panel/main-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds:3),(){
      loggedin(context);

    });
  }
  
  Future<void> loggedin(BuildContext context) async{
    
    
    if(user != null){
      final GetUserDataCOntroller getUserDataCOntroller =
      Get.put(GetUserDataCOntroller());
      var userData = await getUserDataCOntroller.getUserData(user!.uid);

      if(userData[0]['isAdmin']==true){
        Get.offAll(()=>AdminMainScreen());
      }
      else{
        Get.offAll(()=>MainScreen());

      }

    }
    else{
      Get.to(()=> WelcomeScreen());
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
                child: Lottie.asset('assets/images/splash-icon.json'),),
            ),
            Container(
              margin:  EdgeInsets.only(bottom: 20),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                AppConstant.appPowerBy,
                style: TextStyle(
                    color: AppConstant.appMainColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),


              ),
            )
          ],
        ),
      ),
    );
  }
}
