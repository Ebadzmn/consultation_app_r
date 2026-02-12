import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String icon;
  final String color;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, slug, icon, color];
}

