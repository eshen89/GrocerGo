class GroceryItem {
  final String id;
  final String name;
  final String quantity;
  bool isCompleted;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted,
    };
  }
} 