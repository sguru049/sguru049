import 'dart:async';
import 'dart:math';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FortuneWheelListItem {
  String name;
  Function onTap;
  FortuneWheelListItem({
    required this.name,
    required this.onTap,
  });
}

class FortuneWheelScreenController extends GetxController {
  final StreamController<int> _fortuneStreamController =
      StreamController<int>.broadcast();
  Stream<int> get fortuneStream => _fortuneStreamController.stream;

  bool isStreamActive = false;

  List<FortuneWheelListItem> wheelScreenOptions = [
    FortuneWheelListItem(name: 'How to Play', onTap: () {}),
    FortuneWheelListItem(name: 'Terms & Conditions', onTap: () {}),
  ];

  List<FortuneItem> wheelItems = [
    FortuneItem(
        child: Text('     1%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem1, borderWidth: 0)),
    FortuneItem(
        child: Text('     10%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem2, borderWidth: 0)),
    FortuneItem(
        child: Text('     5%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem3, borderWidth: 0)),
    FortuneItem(
        child: Text('     40%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem4, borderWidth: 0)),
    FortuneItem(
        child: Text('     20%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem5, borderWidth: 0)),
    FortuneItem(
        child: Text('     4%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem6, borderWidth: 0)),
    FortuneItem(
        child: Text('     10%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem3, borderWidth: 0)),
    FortuneItem(
        child: Text('     10%', style: kSpinTextStyle),
        style: FortuneItemStyle(color: spinItem4, borderWidth: 0))
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void onSpin() {
    isStreamActive = true;
    final List<SpinItem> items = [
      SpinItem(value: 1, name: 'a'),
      SpinItem(value: 10, name: 'b'),
      SpinItem(value: 5, name: 'c'),
      SpinItem(value: 40, name: 'd'),
      SpinItem(value: 20, name: 'e'),
      SpinItem(value: 4, name: 'f'),
      SpinItem(value: 10, name: 'g'),
      SpinItem(value: 10, name: 'h'),
    ];

    List<String> slectionItems = [];
    for (var i in items) {
      for (var n = 0; n < i.value; n++) {
        slectionItems.add(i.name);
        if (n == i.value - 1) {
          slectionItems.shuffle();
        }
      }
    }

    final int random = Random().nextInt(slectionItems.length);

    final int selecteditem =
        items.map((e) => e.name).toList().indexOf(slectionItems[random]);

    _fortuneStreamController.add(selecteditem);
    6.seconds.delay().then((value) {
      isStreamActive = false;
    });
  }

  @override
  void dispose() {
    _fortuneStreamController.close();
    super.dispose();
  }
}

// temp
class SpinItem {
  int value;
  String name;

  SpinItem({required this.value, required this.name});
}
