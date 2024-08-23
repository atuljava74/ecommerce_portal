import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category_model.dart';
import '../../screens/home_page.dart';
import '../../utils/app_config.dart';
import 'category_event.dart';
import 'category_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}categories.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Category> categories = (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
        emit(CategoryLoaded(categories));
      } else {
        emit(CategoryError('Failed to load categories'));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
