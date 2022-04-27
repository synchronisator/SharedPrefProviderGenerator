import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharedprefprovidergenerator/data_provider.dart';
import 'package:sharedprefprovidergenerator/generator.dart';
import 'package:sharedprefprovidergenerator/item.dart';
import 'package:sharedprefprovidergenerator/listitem.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (BuildContext context) => DataProvider()),
  ], child: const MyApp()));
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

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> items = context.watch<DataProvider>().items;
    String generatedCode = Generator.generateCode(items);
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
                      onPressed: () => context
                          .read<DataProvider>()
                          .addItem(Item(ItemType.string, "", "")),
                      icon: const Icon(Icons.add),
                    );
                  }
                  return ValueListItem(index);
                },
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(generatedCode),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: generatedCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Code copied to clipboard")));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.copy),
                            ))),
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
