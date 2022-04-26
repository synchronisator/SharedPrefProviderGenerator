class Item {
  ItemType type;
  String name;
  var defaultValue;

  Item(this.type, this.name, this.defaultValue);
}

enum ItemType { string, int, double, bool }

extension ItemTypeString on ItemType {
  String getString() {
    switch (this) {
      case ItemType.string:
        return "String";
      case ItemType.int:
        return "int";
      case ItemType.double:
        return "double";
      case ItemType.bool:
        return "bool";
    }
  }

  String hintText() {
    switch (this) {
      case ItemType.string:
        return "(Text)";
      case ItemType.int:
        return "(1)";
      case ItemType.double:
        return "(1.0)";
      case ItemType.bool:
        return "(true)";
    }
  }

  bool isValid(String value) {
    switch (this) {
      case ItemType.string:
        return true;
      case ItemType.int:
        return int.tryParse(value) != null;
      case ItemType.double:
        return double.tryParse(value) != null;
      case ItemType.bool:
        return value == "true" || value == "false";
    }
  }

  String getGetter(){
    switch (this) {
      case ItemType.string:
        return "getString";
      case ItemType.int:
        return "getInt";
      case ItemType.double:
        return "getDouble";
      case ItemType.bool:
        return "getBool";
    }
  }

  String getSetter(){
    switch (this) {
      case ItemType.string:
        return "setString";
      case ItemType.int:
        return "setInt";
      case ItemType.double:
        return "setDouble";
      case ItemType.bool:
        return "setBool";
    }
  }
}