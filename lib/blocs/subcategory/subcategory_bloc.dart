import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_config.dart';
import 'subcategory_event.dart';
import 'subcategory_state.dart';
import '../../models/subcategory_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  SubcategoryBloc() : super(SubcategoryInitial()) {
    on<LoadSubcategories>(_onLoadSubcategories);
  }

  Future<void> _onLoadSubcategories(LoadSubcategories event, Emitter<SubcategoryState> emit) async {
    emit(SubcategoryLoading());

    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}subcategory.php?parent_id=${event.parentId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Subcategory> subcategories = (data['subcategories'] as List)
            .map((subcategory) => Subcategory.fromJson(subcategory))
            .toList();
        emit(SubcategoryLoaded(subcategories));
      } else {
        emit(SubcategoryError('Failed to load subcategories'));
      }
    } catch (e) {
      emit(SubcategoryError(e.toString()));
    }
  }
}
