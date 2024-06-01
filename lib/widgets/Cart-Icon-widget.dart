import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/user-panel/cart-screen.dart';

class CartIcon extends StatelessWidget {
  final String uId;

  CartIcon({required this.uId});

  Stream<int> getCartItemCount(String uId) {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getCartItemCount(uId),
      builder: (context, snapshot) {
        int itemCount = snapshot.data ?? 0;

        return GestureDetector(
          onTap: () => Get.to(() => CartScreen()),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
