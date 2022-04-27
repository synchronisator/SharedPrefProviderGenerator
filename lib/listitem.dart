import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedprefprovidergenerator/data_provider.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class ValueListItem extends StatefulWidget {
  final int itemIndex;

  const ValueListItem(this.itemIndex, {Key? key}) : super(key: key);

  @override
  State<ValueListItem> createState() => _ValueListItemState();
}

class _ValueListItemState extends State<ValueListItem> {
  late TextEditingController textEditingController;
  late TextEditingController textEditingControllerDefault;

  bool nameValid = false;
  bool defaultValid = false;

  @override
  void initState() {
    Item item = Provider.of<DataProvider>(context, listen: false)
        .items[widget.itemIndex];
    textEditingController = TextEditingController(text: item.name);
    textEditingController.addListener(() {
      setState(() {
        validateName();
      });
    });
    nameValid = item.name.isNotEmpty && item.name.startsWith(RegExp(r'[a-z]'));

    textEditingControllerDefault =
        TextEditingController(text: item.defaultValue.toString());
    textEditingControllerDefault.addListener(() {
      setState(() {
        validateDefaultValue();
      });
    });
    defaultValid = item.type.isValid(item.defaultValue);

    super.initState();
  }

  void validateName() {
    nameValid = textEditingController.text.isNotEmpty &&
        textEditingController.text.startsWith(RegExp(r'[a-z]'));
    if (nameValid) {
      Provider.of<DataProvider>(context, listen: false)
          .setItemName(widget.itemIndex, textEditingController.text);
    }
  }

  void validateDefaultValue() {
    defaultValid = Provider.of<DataProvider>(context, listen: false)
        .items[widget.itemIndex]
        .type
        .isValid(textEditingControllerDefault.text);
    if (defaultValid) {
      Provider.of<DataProvider>(context, listen: false)
          .setItemDefault(widget.itemIndex, textEditingControllerDefault.text);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingControllerDefault.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Item item = Provider.of<DataProvider>(context, listen: true)
        .items[widget.itemIndex];
    return Card(
      child: ListTile(
        leading: DropdownButton<ItemType>(
          value: item.type,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (ItemType? newValue) {
            if (newValue != null) {
              setState(() {
                item.type = newValue;
                validateName();
                validateDefaultValue();
              });
            }
          },
          items:
              ItemType.values.map<DropdownMenuItem<ItemType>>((ItemType value) {
            return DropdownMenuItem<ItemType>(
              value: value,
              child: Text(value.getString()),
            );
          }).toList(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: "name"),
            style: TextStyle(color: nameValid ? Colors.black : Colors.red),
          ),
        ),
        subtitle: TextField(
          controller: textEditingControllerDefault,
          decoration:
              InputDecoration(hintText: "defaultValue ${item.type.hintText()}"),
          style: TextStyle(color: defaultValid ? Colors.black : Colors.red),
        ),
      ),
    );
  }
}
