import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FixedExtentScrollController scrollController;
  List<String> currencySortedList = [];

  int index = 2;

  @override
  void initState() {
    currencySortedList = sort(currencyList);
    scrollController = FixedExtentScrollController(
      initialItem: index,
    );
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picker test'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currencySortedList[index],
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 23),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CupertinoButton.filled(
              child: const Text(
                'Open Picker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                scrollController.dispose();
                scrollController =
                    FixedExtentScrollController(initialItem: index);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Select Base Currency:'),
                    actions: [buildPicker()],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),

                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  Widget buildPicker() {
    return StatefulBuilder(
      builder: (context, setState) => SizedBox(
        height: 300,
        child: CupertinoPicker(
          scrollController: scrollController,
          onSelectedItemChanged: (index) {
            setState(() {
              this.index = index;
              final selectedCur = currencySortedList[index];
              print('Selected Currency: $selectedCur');
            });
          },
          itemExtent: 64,
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: CupertinoColors.activeBlue.withOpacity(0.2),
          ),
          children: List.generate(currencySortedList.length, (index) {
            final isSelected = this.index == index;
            final currency = currencySortedList[index];
            final color =
            isSelected ? CupertinoColors.activeBlue : CupertinoColors.black;

            return Center(
              child: Text(
                currency,
                style: TextStyle(fontSize: 32, color: color),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<String> sort(List<String> inputList) {
    inputList.sort();
    return inputList;
  }
}
