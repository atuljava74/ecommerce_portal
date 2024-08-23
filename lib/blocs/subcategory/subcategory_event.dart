import 'package:equatable/equatable.dart';

abstract class SubcategoryEvent extends Equatable {
  const SubcategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadSubcategories extends SubcategoryEvent {
  final String parentId;

  const LoadSubcategories(this.parentId);

  @override
  List<Object> get props => [parentId];
}
