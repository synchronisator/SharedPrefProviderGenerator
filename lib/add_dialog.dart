import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedprefprovidergenerator/data_provider.dart';
import 'package:sharedprefprovidergenerator/item.dart';

class AddDialog extends StatefulWidget {
  final Item item;
  final bool add;

  const AddDialog(this.item, this.add, {Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
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
    return AlertDialog(
      title: const Text("Settings"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<ItemType>(
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
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(hintText: "name"),
                style: TextStyle(color: nameValid ? Colors.black : Colors.red),
              ),
            ),
            TextField(
              controller: textEditingControllerDefault,
              decoration:
              InputDecoration(hintText: "defaultValue ${widget.item.type.hintText()}"),
              style: TextStyle(color: defaultValid ? Colors.black : Colors.red),
            ),
          ],
        ),
      ),

      actions: <Widget>[
        ElevatedButton(
            child: const Text("ok"),
            onPressed: () {
              if(!nameValid || !defaultValid){
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text("Name or Default are not valid")));
                return;
              }
              if(widget.add) {
                context.read<DataProvider>().addItem(widget.item);
              } else {
                context.read<DataProvider>().setItemName(widget.item, widget.item.name);
                context.read<DataProvider>().setItemDefault(widget.item, widget.item.defaultValue);
                context.read<DataProvider>().setItemType(widget.item, widget.item.type);
              }
              Navigator.pop(context);
            }),
      ],
    );
  }
}
