import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlipCardController flipCardController = FlipCardController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.addListener(() {
      setState(() {
        context.read<DataProvider>().items = Generator.generateItems(textEditingController.text);
      });
    });
    super.initState();
  }

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
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
              FlipCard(
                flipOnTouch: false,
                controller: flipCardController,
                fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                direction: FlipDirection.HORIZONTAL, // default
                front: Stack(
                  children: [
                    ListView.builder(
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
                    Positioned(right: 0, child: FloatingActionButton(onPressed: () {
                      textEditingController.text = Generator.generateLines(items);
                      flipCardController.toggleCard();
                    }, child: const Icon(Icons.article),)),
                  ],
                ),
                back: Stack(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: null,
                          controller: textEditingController,
                        ),
                      ),
                    ),
                    Positioned(right: 0, child: FloatingActionButton(onPressed: () => flipCardController.toggleCard(), child: const Icon(Icons.list))),
                  ],
                ),
              ),

            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
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
                )),
          )
        ],
      )),
    );
  }
}
