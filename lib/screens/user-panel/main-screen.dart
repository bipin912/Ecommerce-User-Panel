import 'package:e_com/screens/auth-ui/welcome-screen.dart';
import 'package:e_com/screens/user-panel/all-categories-screen.dart';
import 'package:e_com/screens/user-panel/all-flash-sale-products.dart';
import 'package:e_com/screens/user-panel/all-products-screen.dart';
import 'package:e_com/screens/user-panel/cart-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:e_com/widgets/Cart-Icon-widget.dart';
import 'package:e_com/widgets/all-products-widget.dart';
import 'package:e_com/widgets/banner-widget.dart';
import 'package:e_com/widgets/category-widget.dart';
import 'package:e_com/widgets/custom-drawer-widget.dart';
import 'package:e_com/widgets/heading-widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/flash-sale-widget.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppConstant.appSecondaryColor,
              statusBarIconBrightness: Brightness.light),
          title: Text(
            AppConstant.appMainName,
            style: TextStyle(
              color: AppConstant.appTextColor,
            ),
          ),
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,

          actions:[ Padding(
            padding: const EdgeInsets.all(8.0),
            child: CartIcon(uId: user!.uid),
          )]),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),

              //banners

              BannerWidget(),

              //Heading
              HeadingWidget(
                headingTitle: "Categories",
                headingSubtitle: "According to your Budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See more >",
              ),

              CategoriesWidget(),

              //heading
              HeadingWidget(
                  headingTitle: 'Flash Sale',
                  headingSubtitle: "50% discount",
                  onTap: () => Get.to(() => AllFlashSaleProductsScreen()),
                  buttonText: 'See more >'),

              FlashSaleWidget(),

              HeadingWidget(
                  headingTitle: 'All Products',
                  headingSubtitle: "Top Trending",
                  onTap: () => Get.to(() => AllProductsScreen()),
                  buttonText: 'See more >'),

              AllProductsWidget()
            ],
          ),
        ),
      ),
    );
  }
}
