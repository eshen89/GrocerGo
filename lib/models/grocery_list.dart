import 'grocery_item.dart';

class GroceryList {
  final String id;
  final String name;
  final List<GroceryItem> items;
  final DateTime dueDate;

  GroceryList({
    required this.id,
    required this.name,
    required this.items,
    required this.dueDate,
  });

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    return GroceryList(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List)
          .map((item) => GroceryItem.fromJson(item))
          .toList(),
      dueDate: DateTime.parse(json['dueDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'dueDate': dueDate.toIso8601String(),
    };
  }
}
