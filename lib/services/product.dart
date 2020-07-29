import 'package:firestore_api/firestore_api.dart';

import '../minga_shared.dart';
import '../models/product.dart';

class ProductService {
  final Firestore firestore;

  ProductService(this.firestore);

  Future<void> setProduct(Product product) =>
      firestore.collection('products').document().setData(product.toMap());
  Future<void> updateProduct(Product product) =>
      product.selfRef.update(product.toMap());
  Future<void> deleteProduct(Product product) => product.selfRef.delete();
  Stream<List<Product>> productStream() =>
      firestore.collection('products').snapshots().map(
            (snap) =>
                snap.documents.map((doc) => Product.fromSnapshot(doc)).toList(),
          );
}
