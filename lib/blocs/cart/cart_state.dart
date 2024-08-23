import 'package:equatable/equatable.dart';
import '../../models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double total;

  const CartLoaded(this.cartItems, this.total);

  @override
  List<Object> get props => [cartItems, total];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderSubmitted extends CartState {
  final int orderId;

  const OrderSubmitted(this.orderId);

  @override
  List<Object> get props => [orderId];
}
