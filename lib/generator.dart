import 'package:sharedprefprovidergenerator/item.dart';

class Generator {

  //TODO move as template to asset-folder
  static String template = "import 'package:flutter/material.dart';\n"
      "import 'package:shared_preferences/shared_preferences.dart';\n\n"
      "class SharedPrefsProvider extends ChangeNotifier {\n\n"
      "/// Keys\n\n"
      "/// Internal\n"
      "late final SharedPreferences _prefs;\n"
      "\n/// Values\n\n"
      "SharedPrefsProvider(){\n"
      "_init();\n"
      "}\n"
      "Future<void> _init() async {\n"
      "_prefs = await SharedPreferences.getInstance();\n"
      "// Initialization\n"
      "}\n\n"
      "///Getter\n\n"
      "///Setter\n\n"
      "}\n";

  static String generateCode(List<Item> items) {
    String code = template;
    for (var element in items.reversed) {
      var name =
          element.name.trim().isEmpty ? "undefined" : element.name.trim();
      var type = element.type;
      var defaultValue = element.defaultValue.toString().trim();
      if (type == ItemType.string && !defaultValue.startsWith("\"") && !defaultValue.startsWith("'")) {
        defaultValue = "'$defaultValue'";
      }


          String key =
          "key" + name.toUpperCase().substring(0, 1) + name.substring(1);
      code = code.replaceFirst(
          "/// Keys", "/// Keys\n  static const String $key = '$key';");
      code = code.replaceFirst("/// Values",
          "/// Values\n  ${type.getString()} _$name = $defaultValue;");
      code = code.replaceFirst("// Initialization",
          "// Initialization\n  _$name = _prefs.${type.getGetter()}($key) ?? $defaultValue;");
      code = code.replaceFirst(
          "///Getter", "///Getter\n  ${type.getString()} get $name => _$name;");
      code = code.replaceFirst(
          "///Setter",
          "///Setter\n  "
              "  set $name(${type.getString()} value) {\n"
              "    _$name = value;\n"
              "    _prefs.${type.getSetter()}($key, value);\n"
              "    notifyListeners();\n"
              "  }\n");
    }
    return code;
  }

  static final RegExp exp = RegExp(r"^([a-zA-Z]*) (.*)[ ]*=[ ]*(.*);");

  static String generateLines(List<Item> items) {
    return items.map((e) => "${e.type.getString()} ${e.name} = ${e.defaultValue};").toList().join("\n");
  }

  static List<Item> generateItems(String string) {
    List<Item> ret = [];
    List<String> split = string.split("\n");
    for (var element in split) {
      RegExpMatch? match = exp.firstMatch(element.trim());
      if(match != null) {
        ret.add(Item(ItemType.values.firstWhere((element) => element.name == match.group(1).toString().trim().toLowerCase()), match.group(2).toString().trim(), match.group(3).toString().trim()));
      }
    }
    return ret;
  }

}
