import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_model.dart';
import '../../utils/app_config.dart';
import '../../utils/user_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<SubmitOrder>(_onSubmitOrder);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/get_cart.php?user_id=${UserSession.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<CartItem> cartItems = (data['cart_items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
        double total = data['total'];
        emit(CartLoaded(cartItems, total));
      } else {
        emit(CartError('Failed to load cart'));
      }
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/add_to_cart.php'),
        body: {
          'user_id': UserSession.userId.toString(),
          'product_id': event.productId.toString(),
          'quantity': event.quantity.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        add(LoadCart(UserSession.userId!)); // Reload cart after adding item
      } else {
        emit(CartError(data['message']));
      }
    } catch (e) {
      emit(CartError('Failed to add to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/remove_from_cart.php'),
        body: {
          'cart_id': event.cartId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        add(LoadCart(UserSession.userId!)); // Reload cart after removing item
      } else {
        emit(CartError(data['message']));
      }
    } catch (e) {
      emit(CartError('Failed to remove from cart: $e'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoaded([], 0.0)); // Clear the cart items and reset total to 0
  }

  Future<void> _onSubmitOrder(SubmitOrder event, Emitter<CartState> emit) async {
    print("submiting order");
    try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/submit_order.php'),
          body: {
            'user_id': UserSession.userId.toString(),
            'address': event.address,
            'city': event.city,
            'postal_code': event.postalCode,
            'country': event.country,
            'payment_method': event.paymentMethod,
            'total': event.total.toString(),
            'cart_items': jsonEncode(event.cartItems.map((item1) => item1.toJson()).toList()),
          },
        );

        final data = jsonDecode(response.body);
        if (data['success']) {
          emit(OrderSubmitted(data['order_id']));
          add(ClearCart()); // Clear the cart after successful order submission
        } else {
          emit(CartError(data['message']));
        }
    } catch (e) {
      emit(CartError('Failed to submit order: $e'));
    }
  }
}
