import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/models/cart-model.dart';
import 'package:e_com/models/product-model.dart';
import 'package:e_com/utils/app-constant.dart';
import 'package:e_com/widgets/Cart-Icon-widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';


import 'cart-screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;

  ProductDetailsScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Product Details",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CartIcon(uId: user!.uid),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 60,
            ),

            //product images
            CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imageUrls) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls,
                        fit: BoxFit.cover,
                        width: Get.width - 35,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(child: CupertinoActivityIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 1.5,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productModel.productName,
                            ),
                            Icon(Icons.favorite_outline)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Category: " + widget.productModel.categoryName,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            widget.productModel.isSale == true &&
                                    widget.productModel.salePrice != ''
                                ? Text(
                                    "Rs: " + widget.productModel.salePrice,
                                  )
                                : Text(
                                    "Rs: " + widget.productModel.fullPrice,
                                  )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Description: " +
                              widget.productModel.productDescription,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                  color: AppConstant.appSecondaryColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: TextButton(
                                  child: Text(
                                    'Whatsapp',
                                    style: TextStyle(
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    sendMessageOnWhatsapp(
                                        productModel: widget.productModel);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                  color: AppConstant.appSecondaryColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: TextButton(
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await checkProductExistence(
                                        context: context,
                                        uId: user!.uid);

                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<void> sendMessageOnWhatsapp({

    required ProductModel productModel,
  }) async {
    final String number = "+9779804071418";
    final String message = "Hello Bipin \n I want to Know about this product \n ${productModel.productName} \n ${productModel.productId}";
    final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$number&text=${Uri.encodeComponent(message)}');
    final Uri webUrl = Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');

    print('Constructed WhatsApp URL: $whatsappUrl'); // Log the WhatsApp URL
    print('Constructed Web URL: $webUrl'); // Log the Web URL

    if (await canLaunchUrl(whatsappUrl)) {
      print('Launching WhatsApp URL: $whatsappUrl'); // Log successful launch attempt
      await launchUrl(whatsappUrl);
    } else if (await canLaunchUrl(webUrl)) {
      print('Launching Web URL: $webUrl'); // Log successful launch attempt
      await launchUrl(webUrl);
    } else {
      print('Could not launch $whatsappUrl or $webUrl'); // Log failure
      throw 'Could not launch $whatsappUrl or $webUrl';
    }
  }

  //Check product exist or not

  Future<void> checkProductExistence({
    required BuildContext context,
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print('Product exist');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppConstant.appSecondaryColor,
          content: Text('Product quantity updated in the cart',
          style: TextStyle(color: AppConstant.appTextColor),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
      );

      await documentReference.set(cartModel.toMap());
      print('Product Added');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppConstant.appSecondaryColor,
          content: Text('Product added to the cart',
          style: TextStyle(color: AppConstant.appTextColor),),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
