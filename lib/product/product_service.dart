import 'package:firestore_api/firestore_api.dart';

import '../minga_shared.dart';
import 'product_model.dart';

class ProductService {
  final Firestore firestore;
  final CollectionReference coll;
  ProductService(this.firestore)
      : coll = firestore.collection('productClasses');

  Future<void> setProduct(ProductClass product) =>
      coll.document().setData(product.toMap());
  Future<void> updateProduct(ProductClass product) =>
      product.selfRef.update(product.toMap());
  Future<void> deleteProduct(ProductClass product) => product.selfRef.delete();
  Stream<List<ProductClass>> productStream() => coll.snapshots().map(
        (snap) => snap.documents
            .map((doc) => ProductClass.fromSnapshot(doc))
            .toList(),
      );
}
