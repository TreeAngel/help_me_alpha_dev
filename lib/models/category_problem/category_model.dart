import 'package:equatable/equatable.dart';

class DataCategory {
  final List<CategoryModel> data;

  DataCategory({
    required this.data,
  });

  factory DataCategory.fromJson(Map<String, dynamic> json) => DataCategory(
        data: List<CategoryModel>.from(
          json['data'].map(
            (category) => CategoryModel.fromModel(category),
          ),
        ),
      );
}

class CategoryModel extends Equatable {
  final int id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromModel(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? json['helper_id'],
        name: json['name'],
      );

  @override
  String toString() => 'CategoryModel($id, $name)';
  
  @override
  List<Object?> get props => [id, name];

}
