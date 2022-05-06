import 'package:sharedprefprovidergenerator/item.dart';

class Generator {


  static String mainTemplate =
  "void main() async {\n"
    "\tWidgetsFlutterBinding.ensureInitialized();\n"
    "\tSharedPrefsProvider sharedPrefsProvider = await SharedPrefsProvider.create();\n"
    "\trunApp(MultiProvider(providers: [\n"
      "\t\tChangeNotifierProvider(create: (BuildContext context) => sharedPrefsProvider),\n"
    "\t], child: const MyApp()));\n"
  "}";

  //TODO move as template to asset-folder
  static String template = "import 'package:flutter/material.dart';\n"
      "import 'package:shared_preferences/shared_preferences.dart';\n\n"
      "class SharedPrefsProvider extends ChangeNotifier {\n\n"
      "/// Keys\n\n"
      "/// Values\n\n"
      "/// Internal\n"
      "late final SharedPreferences _prefs;\n"
      "static final SharedPrefsProvider _instance = SharedPrefsProvider._internal();\n\n"
      "factory SharedPrefsProvider() => _instance;\n\n"
      "SharedPrefsProvider._internal();\n\n"

      "static create() async{\n"
        "\tvar sharedPrefsProvider = SharedPrefsProvider._internal();\n"
        "\tawait sharedPrefsProvider._init();\n"
        "\treturn sharedPrefsProvider;\n"
      "}\n\n"

      "Future<void> _init() async {\n"
      "\t_prefs = await SharedPreferences.getInstance();\n"
      "\t///Initialization\n"
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
          "/// Keys", "/// Keys\n\tstatic const String $key = '$key';");
      code = code.replaceFirst("/// Values",
          "/// Values\n\t${type.getString()} _$name = $defaultValue;");
      code = code.replaceFirst("///Initialization",
          "///Initialization\n\t\t_$name = _prefs.${type.getGetter()}($key) ?? $defaultValue;");
      code = code.replaceFirst(
          "///Getter", "///Getter\n\t${type.getString()} get $name => _$name;");
      code = code.replaceFirst(
          "///Setter",
          "///Setter\n"
              "\tset $name(${type.getString()} value) {\n"
              "\t\t_$name = value;\n"
              "\t\t_prefs.${type.getSetter()}($key, value);\n"
              "\t\tnotifyListeners();\n"
              "\t}\n");
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
