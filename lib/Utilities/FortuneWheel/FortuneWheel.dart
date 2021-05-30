import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelScreen extends StatelessWidget {
  FortuneWheelScreen({Key? key}) : super(key: key);

  final List<FortuneDataModel> items = [
    FortuneDataModel(value: '10\$', percentage: 24),
    FortuneDataModel(value: '100\$', percentage: 5),
    FortuneDataModel(value: '1\$', percentage: 60),
    FortuneDataModel(value: '100000\$', percentage: 1),
    FortuneDataModel(value: '50\$', percentage: 10),
  ];

  @override
  Widget build(BuildContext context) {
    print(getSelectedObject());
    return Scaffold(
      appBar: AppBar(title: Text('Forutne Wheel')),
    );
  }

  String getSelectedObject() {
    final List<String> randomList = [];
    for (var item in items) {
      var newArray = List.filled(item.percentage ?? 1, item.value);
      randomList.addAll(newArray);
      print('afer adding ${item.value} $randomList');
      randomList.shuffle();
      print('afer shuffling in loop $randomList');
    }

    print('afer loop over $randomList');
    randomList.shuffle();
    print('afer loop over shuffle $randomList');

    final int randomNo = Random().nextInt(randomList.length);
    return randomList[randomNo];
  }
}

class FortuneDataModel {
  String value;
  int? percentage;

  FortuneDataModel({required this.value, required this.percentage});
}
