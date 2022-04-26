import 'package:sharedprefprovidergenerator/item.dart';

class Generator {

  String template = "import 'package:flutter/material.dart';\n"
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





  String generateCode(List<Item> items){
    String code = template;
    for (var element in items.reversed) {
      code = code.replaceFirst("/// Keys", "/// Keys\n  static const String key_${element.name} = 'key_${element.name}';");
      code = code.replaceFirst("/// Values", "/// Values\n  ${element.type.getString()} _${element.name} = ${element.defaultValue.toString()};");
      code = code.replaceFirst("// Initialization", "// Initialization\n  _${element.name} = _prefs.${element.type.getGetter()}(key_${element.name}) ?? ${element.defaultValue.toString()};");

      code = code.replaceFirst("///Getter", "///Getter\n  ${element.type.getString()} get ${element.name} => _${element.name};");
      code = code.replaceFirst("///Setter", "///Setter\n  "
          "  set ${element.name}(${element.type.getString()} value) {\n"
          "    _${element.name} = value;\n"
          "    _prefs.${element.type.getSetter()}(key_${element.name}, value);\n"
          "  }\n"

      );



    }
    return code;
  }


}