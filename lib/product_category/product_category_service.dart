import 'package:firestore_api/firestore_api.dart';

import 'product_category.dart';

class ProductService {
  final Firestore firestore;
  final CollectionReference coll;
  ProductService(this.firestore)
      : coll = firestore.collection('productCategories');

  Future<void> setProduct(ProductCategory productCategory) =>
      coll.document().setData(productCategory.toMap());
  Future<void> updateProduct(ProductCategory productCategory) =>
      productCategory.selfRef.update(productCategory.toMap());
  Future<void> deleteProduct(ProductCategory productCategory) =>
      productCategory.selfRef.delete();
  Stream<List<ProductCategory>> get stream => coll.snapshots().map(
        (snap) => snap.documents
            .map((doc) => ProductCategory.fromSnapshot(doc))
            .toList(),
      );
}
