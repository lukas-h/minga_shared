import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/product.dart';

import '../models/product.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetProductEvent extends ProductEvent {
  final Product product;

  SetProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  UpdateProductEvent(this.product);
}

class DeleteProductEvent extends ProductEvent {
  final Product product;

  DeleteProductEvent(this.product);
}

class ProductLoadingEvent extends ProductEvent {}

class ProductSnapshotEvent extends ProductEvent {
  final List<Product> products;

  ProductSnapshotEvent(this.products);
}

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductLoadingState extends ProductState {}

class ProductSnapshotState extends ProductState {
  final List<Product> products;

  ProductSnapshotState(this.products);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._productService) : super(ProductLoadingState());
  final ProductService _productService;
  StreamSubscription _subscription;

  Stream<ProductState> _mapStreamToState() async* {
    await _subscription?.cancel();
    _subscription = _productService
        .productStream()
        .listen((snapshot) => add(ProductSnapshotEvent(snapshot)));
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is SetProductEvent) {
      yield* _mapSetProductToState(event);
    } else if (event is UpdateProductEvent) {
      yield* mapUpdateProductToState(event);
    } else if (event is DeleteProductEvent) {
      yield* mapdeleteProductToState(event);
    } else if (event is ProductSnapshotEvent) {
      yield ProductSnapshotState(event.products);
    } else if (event is ProductLoadingEvent) {
      yield ProductLoadingState();
      yield* _mapStreamToState();
    }
  }

  Stream<ProductState> mapdeleteProductToState(
      DeleteProductEvent event) async* {
    _productService.deleteProduct(event.product);
  }

  Stream<ProductState> mapUpdateProductToState(
      UpdateProductEvent event) async* {
    _productService.updateProduct(event.product);
  }

  Stream<ProductState> _mapSetProductToState(SetProductEvent event) async* {
    _productService.setProduct(event.product);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
