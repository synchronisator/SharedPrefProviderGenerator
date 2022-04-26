import 'package:flutter/material.dart';
import 'package:sharedprefprovidergenerator/genarator.dart';
import 'package:sharedprefprovidergenerator/item.dart';
import 'package:sharedprefprovidergenerator/listitem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPrefsProviderGenerator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Item> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('SharedPrefsProviderGenerator'),
      ),
      body: Center(
          child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return IconButton(
                      onPressed: () => setState(() {
                        items.add(Item(ItemType.string, "", ""));
                      }),
                      icon: const Icon(Icons.add),
                    );
                  }
                  return ValueListItem(items[index], () => setState(() {}));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(Generator().generateCode(items)),
            )),
          )
        ],
      )),
    );
  }
}
