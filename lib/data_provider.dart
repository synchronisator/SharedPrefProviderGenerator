import 'package:flutter/material.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class DataProvider extends ChangeNotifier {
  final List<Item> _items = [Item(ItemType.string, "example", "dummy")];

  static final DataProvider _instance = DataProvider._internal();
  factory DataProvider() => _instance;

  DataProvider._internal();


  List<Item> get items => _items;

  set items(List<Item> value) {
    _items.clear();
    _items.addAll(value);
    notifyListeners();
  }

  void addItem(Item item) {
    items.add(item);
    notifyListeners();
  }

  void setItemDefault(Item item, String text) {
    item.defaultValue = text;
    notifyListeners();
  }

  void setItemName(Item item, String text) {
    item.name = text;
    notifyListeners();
  }
}
