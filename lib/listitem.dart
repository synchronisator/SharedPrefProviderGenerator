import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedprefprovidergenerator/data_provider.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class ValueListItem extends StatefulWidget {
  final Item item;

  const ValueListItem(this.item, {Key? key}) : super(key: key);

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
    textEditingController = TextEditingController(text: widget.item.name);
    textEditingController.addListener(() {
      setState(() {
        validateName();
      });
    });
    nameValid = widget.item.name.isNotEmpty && widget.item.name.startsWith(RegExp(r'[a-z]'));

    textEditingControllerDefault =
        TextEditingController(text: widget.item.defaultValue.toString());
    textEditingControllerDefault.addListener(() {
      setState(() {
        validateDefaultValue();
      });
    });
    defaultValid = widget.item.type.isValid(widget.item.defaultValue);

    super.initState();
  }

  void validateName() {
    nameValid = textEditingController.text.isNotEmpty &&
        textEditingController.text.startsWith(RegExp(r'[a-z]'));
    if (nameValid) {
      Provider.of<DataProvider>(context, listen: false)
          .setItemName(widget.item, textEditingController.text);
    }
  }

  void validateDefaultValue() {
    defaultValid = widget.item
        .type
        .isValid(textEditingControllerDefault.text);
    if (defaultValid) {
      Provider.of<DataProvider>(context, listen: false)
          .setItemDefault(widget.item, textEditingControllerDefault.text);
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
    return Card(
      child: ListTile(
        leading: DropdownButton<ItemType>(
          value: widget.item.type,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (ItemType? newValue) {
            if (newValue != null) {
              setState(() {
                widget.item.type = newValue;
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
              InputDecoration(hintText: "defaultValue ${widget.item.type.hintText()}"),
          style: TextStyle(color: defaultValid ? Colors.black : Colors.red),
        ),
      ),
    );
  }
}
