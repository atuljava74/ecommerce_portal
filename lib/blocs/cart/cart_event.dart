import 'package:ecommerce_portal/models/cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  final int userId;

  const LoadCart(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddToCart extends CartEvent {
  final int productId;
  final int quantity;

  const AddToCart(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveFromCart extends CartEvent {
  final int cartId;

  const RemoveFromCart(this.cartId);

  @override
  List<Object> get props => [cartId];
}

class ClearCart extends CartEvent {}

class SubmitOrder extends CartEvent {
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final String total;

  const SubmitOrder({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.paymentMethod,
    required this.cartItems, required this.total,
  });

  @override
  List<Object> get props => [address, city, postalCode, country, paymentMethod, cartItems, total];
}
