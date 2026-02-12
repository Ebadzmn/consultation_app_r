import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.icon,
    required super.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    int id;
    if (idRaw is num) {
      id = idRaw.toInt();
    } else {
      id = int.tryParse(idRaw.toString()) ?? 0;
    }

    return CategoryModel(
      id: id,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      color: json['color']?.toString() ?? '',
    );
  }
}

