import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecom_demo/domain/product.dart';

class FirebaseClient {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<Product> get(String productID) async {
    final snapshot = await products.doc(productID).get();
    return Product.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}
