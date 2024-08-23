import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_config.dart';
import '../../utils/user_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'orders_event.dart';
import 'orders_state.dart';
import '../../models/orders_model.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());

    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/get_orders.php?user_id=${event.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Order> orders = (data['orders'] as List)
            .map((order) => Order.fromJson(order))
            .toList();
        emit(OrdersLoaded(orders));
      } else {
        emit(OrdersError('Failed to load orders'));
      }
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }
}
