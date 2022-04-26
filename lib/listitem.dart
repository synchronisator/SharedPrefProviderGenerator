
import 'package:flutter/material.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class ValueListItem extends StatefulWidget {
  final Item item;
  final Function f;

  ValueListItem(this.item, this.f, {Key? key}) : super(key: key);

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
        nameValid = textEditingController.text.isNotEmpty &&
            textEditingController.text.startsWith(RegExp(r'[a-z]'));
        if(nameValid){
          widget.item.name = textEditingController.text;
          widget.f();
        }
      });
    });

    textEditingControllerDefault =
        TextEditingController(text: widget.item.defaultValue.toString());
    textEditingControllerDefault.addListener(() {
      setState(() {
        defaultValid =
            widget.item.type.isValid(textEditingControllerDefault.text);

        if(defaultValid){
          if (widget.item.type == ItemType.string) {
            widget.item.defaultValue = "'${textEditingControllerDefault.text}'";
          } else {
            widget.item.defaultValue = textEditingControllerDefault.text;
          }
          widget.f();
        }
      });
    });
    super.initState();
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
            decoration: InputDecoration(hintText: "name"),
            style: TextStyle(color: nameValid ? Colors.black : Colors.red),
          ),
        ),
        subtitle: TextField(
          controller: textEditingControllerDefault,
          decoration: InputDecoration(
              hintText: "defaultvalue ${widget.item.type.hintText()}"),
          style: TextStyle(color: defaultValid ? Colors.black : Colors.red),
        ),
      ),
    );
  }
}
