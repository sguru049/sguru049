import 'dart:html';
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
  final htmlId = UniqueKey().toString();
  final iFrame = IFrameElement();

  List<FortuneWheelListItem> wheelScreenOptions = [
    FortuneWheelListItem(name: 'How to play', onTap: () {}),
    FortuneWheelListItem(name: 'Terms & conditions', onTap: () {}),
    FortuneWheelListItem(name: 'View ad to get another chance', onTap: () {}),
  ];

  List<FortuneItem> wheelItems = [
    FortuneItem(
        child: Text('Item1'),
        style: FortuneItemStyle(color: Colors.pink.shade50)),
    FortuneItem(
        child: Text('Item2'),
        style: FortuneItemStyle(color: Colors.pink.shade200)),
    FortuneItem(
        child: Text('Item3'),
        style: FortuneItemStyle(color: Colors.pink.shade400)),
    FortuneItem(
        child: Text('Item4'),
        style: FortuneItemStyle(color: Colors.pink.shade300)),
    FortuneItem(
        child: Text('Item5'),
        style: FortuneItemStyle(color: Colors.pink.shade500)),
    FortuneItem(
        child: Text('Item6'),
        style: FortuneItemStyle(color: Colors.pink.shade600)),
    FortuneItem(
        child: Text('Item7'),
        style: FortuneItemStyle(color: Colors.pink.shade700)),
    FortuneItem(
        child: Text('Item8'),
        style: FortuneItemStyle(color: Colors.pink.shade800))
  ];

  @override
  void onInit() {
    if (iFrame.contentWindow != null) {
      iFrame.contentWindow!.addEventListener('onResult', (event) {
        print('onResult');
        print(event);
      });
      iFrame.contentWindow!.addEventListener('onGameEnd', (event) {
        print('onGameEnd');
        print(event);
      });
    }
    iFrame.addEventListener('onResult', (e) {
      print('onResult');
      print(e);
    }, true);
    iFrame.addEventListener('onGameEnd', (e) {
      print('onGameEnd');
      print(e);
    });
    iFrame.addEventListener('onWheelPress', (e) {
      print('onWheelPress');
      print(e);
    });
    iFrame.addEventListener('onWheelDragEnd', (e) {
      print('onWheelDragEnd');
      print(e);
    });
    super.onInit();
  }
}
