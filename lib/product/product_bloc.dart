import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'product_service.dart';

import 'product_model.dart';

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

class ProductSuccessState extends ProductState {
  final String message;

  ProductSuccessState(this.message);
}

class ProductFailureState extends ProductState {
  final String message;

  ProductFailureState(this.message);
}

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
    try {
      await _productService.deleteProduct(event.product);
      yield ProductSuccessState('Success deleting \'${event.product.label}\'');
    } catch (e) {
      yield ProductFailureState('Error deleting  \'${event.product.label}\'');
    }
    add(ProductLoadingEvent());
  }

  Stream<ProductState> mapUpdateProductToState(
      UpdateProductEvent event) async* {
    try {
      await _productService.updateProduct(event.product);
      yield ProductSuccessState('Success updating \'${event.product.label}\'');
    } catch (e) {
      yield ProductFailureState('Error updating \'${event.product.label}\'');
    }
    add(ProductLoadingEvent());
  }

  Stream<ProductState> _mapSetProductToState(SetProductEvent event) async* {
    try {
      await _productService.setProduct(event.product);
      yield ProductSuccessState('Success creating \'${event.product.label}\'');
    } catch (e) {
      yield ProductFailureState('Error creating \'${event.product.label}\'');
    }
    add(ProductLoadingEvent());
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
