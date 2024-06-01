import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/controllers/cart-price-controller.dart';
import 'package:e_com/screens/user-panel/checkout-screen.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

import '../../models/cart-model.dart';
import '../../models/order-model.dart';
import '../../models/product-model.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'All Orders',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(user!.uid)
              .collection('confirmOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No products found"),
              );
            }
            if (snapshot.data != null) {
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];

                        OrderModel orderModel = OrderModel(
                            productId: productData['productId'],
                            categoryId: productData['categoryId'],
                            productName: productData['productName'],
                            categoryName: productData['categoryName'],
                            salePrice: productData['salePrice'],
                            fullPrice: productData['fullPrice'],
                            productImages: productData['productImages'],
                            deliveryTime: productData['deliveryTime'],
                            isSale: productData['isSale'],
                            productDescription:
                            productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt'],
                            productQuantity: productData['productQuantity'],
                            productTotalPrice:
                            double.parse(productData['productTotalPrice'].toString()),
                            customerId: productData['customerId'],
                            customerPhone: productData['customerPhone'],
                          customerAddress: productData['customerAddress'],
                          customerDeviceToken: productData['customerDeviceToken'],
                          customerName: productData['customerName'],
                          status: productData['status'],
                          
                        );

                        //calculate price
                        productPriceController.fetchProductPrice();

                        return Card(
                          elevation: 5,
                          color: AppConstant.appTextColor,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppConstant.appMainColor,
                              backgroundImage:
                              NetworkImage(orderModel.productImages[0]),
                            ),
                            title: Text(orderModel.productName),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    orderModel.productTotalPrice.toString()
                                ),
                          SizedBox(
                            width: Get.width / 20,
                          ),

                          orderModel.status != true ? Text("Pending...",
                          style: TextStyle(color: Colors.green),):
                              Text('Delivered',
                                style: TextStyle(color: Colors.red),)

                              ],
                            ),
                          ),
                        );

                      }));
            }
            return Container();
          }),

    );
  }
}
