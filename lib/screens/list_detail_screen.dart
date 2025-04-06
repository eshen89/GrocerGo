import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../widgets/item_card.dart';
import '../providers/grocery_provider.dart';
import '../models/grocery_list.dart';

class ListDetailScreen extends StatelessWidget {
  final String listId;
  final String title;

  const ListDetailScreen({
    super.key,
    required this.listId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAddItemField(context),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<GroceryProvider>(
                    builder: (context, provider, child) {
                      final list = provider.lists.firstWhere(
                        (list) => list.id == listId,
                        orElse: () => GroceryList(
                          id: listId,
                          name: title,
                          items: [],
                          dueDate: DateTime.now(),
                        ),
                      );

                      if (list.items.isEmpty) {
                        return const Center(
                          child: Text('No items in this list yet. Add some!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: list.items.length,
                        itemBuilder: (context, index) {
                          final item = list.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ItemCard(
                              name: item.name,
                              quantity: item.quantity,
                              isCompleted: item.isCompleted,
                              onToggle: () {
                                provider.toggleItemCompletion(listId, item.id);
                              },
                              onDelete: () {
                                provider.deleteItem(listId, item.id);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemField(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Item name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    Provider.of<GroceryProvider>(context, listen: false)
                        .addItem(
                      listId,
                      nameController.text,
                      quantityController.text.isEmpty
                          ? '1'
                          : quantityController.text,
                    );
                    nameController.clear();
                    quantityController.clear();
                  }
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
