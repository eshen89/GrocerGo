import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String quantity;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
