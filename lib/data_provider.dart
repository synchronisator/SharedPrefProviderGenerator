import 'package:flutter/material.dart';
import 'package:sharedprefprovidergenerator/generator.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class DataProvider extends ChangeNotifier {
  final List<Item> _items = [Item(ItemType.string, "example", "dummy")];

  static final DataProvider _instance = DataProvider._internal();
  factory DataProvider() => _instance;

  DataProvider._internal();

  set items(List<Item> value) {
    _items.clear();
    _items.addAll(value);
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
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

  int itemLength() {
    return _items.length;
  }

  String getGeneratedCode() {
    return Generator.generateCode(_items);
  }

  String getLines() {
    return Generator.generateLines(_items);
  }

  Item? getItemAt(int index) {
    if(index >= _items.length){
      return null;
    }
    return _items[index];
  }

  void setItemType(Item item, ItemType type) {
    item.type = type;
    notifyListeners();
  }

  delete(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}