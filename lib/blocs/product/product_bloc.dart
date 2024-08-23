import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_config.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}products.php?subcategory_id=${event.categoryId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Product> products = (data['products'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        emit(ProductLoaded(products));
      } else {
        emit(ProductError('Failed to load products'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
