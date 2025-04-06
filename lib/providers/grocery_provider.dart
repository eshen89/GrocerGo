import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/grocery_list.dart';
import '../models/grocery_item.dart';

class GroceryProvider extends ChangeNotifier {
  List<GroceryList> _lists = [];
  bool _isLoading = false;

  List<GroceryList> get lists => _lists;
  bool get isLoading => _isLoading;

  GroceryProvider() {
    _loadLists();
  }

  Future<void> _loadLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final listsJson = prefs.getString('grocery_lists');

      if (listsJson != null) {
        final List<dynamic> decodedLists = json.decode(listsJson);
        _lists =
            decodedLists.map((list) => GroceryList.fromJson(list)).toList();
      } else {
        // Add some sample data if no lists exist
        _lists = [
          GroceryList(
            id: '1',
            name: 'Weekly Essentials',
            items: [
              GroceryItem(id: '1', name: 'Milk', quantity: '2 gallons'),
              GroceryItem(id: '2', name: 'Eggs', quantity: '1 dozen'),
              GroceryItem(id: '3', name: 'Bread', quantity: '2 loaves'),
            ],
            dueDate: DateTime.now().add(const Duration(days: 1)),
          ),
          GroceryList(
            id: '2',
            name: 'Party Supplies',
            items: [
              GroceryItem(id: '4', name: 'Chips', quantity: '3 bags'),
              GroceryItem(id: '5', name: 'Soda', quantity: '2 liters'),
              GroceryItem(id: '6', name: 'Cookies', quantity: '1 box'),
            ],
            dueDate: DateTime.now().add(const Duration(days: 3)),
          ),
        ];
        await _saveLists();
      }
    } catch (e) {
      debugPrint('Error loading lists: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listsJson =
          json.encode(_lists.map((list) => list.toJson()).toList());
      await prefs.setString('grocery_lists', listsJson);
    } catch (e) {
      debugPrint('Error saving lists: $e');
    }
  }

  Future<void> addList(String name, DateTime dueDate) async {
    final newList = GroceryList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: [],
      dueDate: dueDate,
    );

    _lists.add(newList);
    await _saveLists();
    notifyListeners();
  }

  Future<void> addItem(String listId, String name, String quantity) async {
    final listIndex = _lists.indexWhere((list) => list.id == listId);
    if (listIndex != -1) {
      final newItem = GroceryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        quantity: quantity,
      );

      // Create a new list with the updated items
      final updatedList = GroceryList(
        id: _lists[listIndex].id,
        name: _lists[listIndex].name,
        items: [..._lists[listIndex].items, newItem],
        dueDate: _lists[listIndex].dueDate,
      );

      _lists[listIndex] = updatedList;
      await _saveLists();
      notifyListeners();
    }
  }

  Future<void> toggleItemCompletion(String listId, String itemId) async {
    final listIndex = _lists.indexWhere((list) => list.id == listId);
    if (listIndex != -1) {
      final itemIndex =
          _lists[listIndex].items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        // Create a new item with toggled completion status
        final updatedItem = GroceryItem(
          id: _lists[listIndex].items[itemIndex].id,
          name: _lists[listIndex].items[itemIndex].name,
          quantity: _lists[listIndex].items[itemIndex].quantity,
          isCompleted: !_lists[listIndex].items[itemIndex].isCompleted,
        );

        // Create a new list with the updated items
        final updatedItems = List<GroceryItem>.from(_lists[listIndex].items);
        updatedItems[itemIndex] = updatedItem;

        final updatedList = GroceryList(
          id: _lists[listIndex].id,
          name: _lists[listIndex].name,
          items: updatedItems,
          dueDate: _lists[listIndex].dueDate,
        );

        _lists[listIndex] = updatedList;
        await _saveLists();
        notifyListeners();
      }
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    final listIndex = _lists.indexWhere((list) => list.id == listId);
    if (listIndex != -1) {
      // Create a new list with the item removed
      final updatedList = GroceryList(
        id: _lists[listIndex].id,
        name: _lists[listIndex].name,
        items:
            _lists[listIndex].items.where((item) => item.id != itemId).toList(),
        dueDate: _lists[listIndex].dueDate,
      );

      _lists[listIndex] = updatedList;
      await _saveLists();
      notifyListeners();
    }
  }

  Future<void> deleteList(String listId) async {
    _lists.removeWhere((list) => list.id == listId);
    await _saveLists();
    notifyListeners();
  }
}
