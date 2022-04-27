import 'package:flutter/material.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class DataProvider extends ChangeNotifier {
  final List<Item> _items = [Item(ItemType.string, "example", "dummy")];

  List<Item> get items => _items;

  void addItem(Item item) {
    items.add(item);
    notifyListeners();
  }

  void setItemDefault(int itemIndex, String text) {
    if (items[itemIndex].type == ItemType.string) {
      items[itemIndex].defaultValue = "'$text'";
    } else {
      items[itemIndex].defaultValue = text;
    }
    notifyListeners();
  }

  void setItemName(int itemIndex, String text) {
    items[itemIndex].name = text;
    notifyListeners();
  }
}
