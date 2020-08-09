import 'package:firestore_api/firestore_api.dart';

import '../minga_shared.dart';
import 'product_model.dart';

class ProductService {
  final Firestore firestore;

  ProductService(this.firestore);

  Future<void> setProduct(ProductClass product) =>
      firestore.collection('products').document().setData(product.toMap());
  Future<void> updateProduct(ProductClass product) =>
      product.selfRef.update(product.toMap());
  Future<void> deleteProduct(ProductClass product) => product.selfRef.delete();
  Stream<List<ProductClass>> productStream() =>
      firestore.collection('products').snapshots().map(
            (snap) => snap.documents
                .map((doc) => ProductClass.fromSnapshot(doc))
                .toList(),
          );
}
