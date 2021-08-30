import 'dart:async';
import 'dart:math';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'FortuneWheelYouWonAlert/YouWonAlert.dart';

class FortuneWheelListItem {
  String name;
  Function onTap;
  FortuneWheelListItem({
    required this.name,
    required this.onTap,
  });
}

class FortuneWheelScreenController extends GetxController {
  final UserProfileScreenController userController = Get.find();
  //
  final StreamController<int> _fortuneStreamController =
      StreamController<int>.broadcast();
  Stream<int> get fortuneStream => _fortuneStreamController.stream;

  bool isStreamActive = false;
  RxDouble rotationValue = 0.0.obs;
  Duration rotationDuration = 1000.milliseconds;

  Rx<Alignment> clickButtonAlignment = Alignment.centerLeft.obs;
  Duration clickAnimationDuration = 500.milliseconds;
  bool haveToShowClickAnimation = true;

  RxBool isCloseButtonTap = false.obs;
  DateTime lastSpinTime = DateTime(0);

  List<FortuneWheelListItem> wheelScreenOptions = [
    FortuneWheelListItem(name: 'How to Play', onTap: () {}),
    FortuneWheelListItem(name: 'Terms & Conditions', onTap: () {}),
  ];

  List<String> wheelItemsDeals = [
    'Free Beauty Treatment',
    'Better luck next time',
    '50% off on Botox',
    '100 BC',
    '500 BC',
    '250 BC',
  ];

  List<FortuneItem> wheelItems = [
    FortuneItem(
        child: Text(
          '       Free Beauty\n      Treatment',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem1, borderWidth: 0)),
    FortuneItem(
        child: Text(
          '     Better\n     luck next\n     time',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem2, borderWidth: 0)),
    FortuneItem(
        child: Text(
          '       50% off\n       on Botox',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem3, borderWidth: 0)),
    FortuneItem(
        child: Text(
          '     100 BC',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem4, borderWidth: 0)),
    FortuneItem(
        child: Text(
          '     500 BC',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem5, borderWidth: 0)),
    FortuneItem(
        child: Text(
          '      250 BC',
          style: kSpinItemTextStyle,
          textAlign: TextAlign.center,
        ),
        style: FortuneItemStyle(color: spinItem6, borderWidth: 0)),
  ];

  @override
  void onInit() {
    startAnimateClickButton();
    Future.delayed(1.seconds).then((value) {
      checkTimerAndSet();
    });
    super.onInit();
  }

  void startAnimateClickButton() {
    Timer.periodic(clickAnimationDuration, (timer) {
      (clickButtonAlignment.value == Alignment.centerRight)
          ? clickButtonAlignment.value = Alignment.centerLeft
          : clickButtonAlignment.value = Alignment.centerRight;
    });
  }

  void onSpin(BuildContext context) {
    isStreamActive = true;
    haveToShowClickAnimation = false;
    rotationValue.value = 200;
    rotationDuration.delay().then((value) {
      rotationDuration = 300.milliseconds;
      rotationValue.value = 300;
      rotationDuration.delay().then((value) {
        rotationDuration = 100.milliseconds;
        rotationValue.value = 500;
        rotationDuration.delay().then((value) {
          final List<SpinItem> items = [
            SpinItem(value: 1, name: 'a'),
            SpinItem(value: 10, name: 'b'),
            SpinItem(value: 5, name: 'c'),
            SpinItem(value: 40, name: 'd'),
            SpinItem(value: 20, name: 'e'),
            SpinItem(value: 24, name: 'f'),
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

          print(selecteditem);

          _fortuneStreamController.add(selecteditem);
          rotationDuration = 10.milliseconds;
          rotationValue.value = 0.0;
          5500.milliseconds.delay().then((value) {
            isStreamActive = false;
            rotationDuration = 1000.milliseconds;
            // Save time to local
            // if login then save time to firebase
            if (userController.hasUser.value) {
              FirebaseFirestore.instance
                  .collection(kUserCollectionKey)
                  .doc(userController.user.value.docId)
                  .update({
                kLastSpinTimekey: DateTime.now().toString(),
              });
            }
            // save time to local
            CookieManager.addToCookie(
                kLastSpinTimekey, '${new DateTime.now().toString()}');
            lastSpinTime = DateTime.now();

            // Alert
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return YouWonAlert(
                  screenWidth: MediaQuery.of(context).size.width,
                  screenHeight: MediaQuery.of(context).size.height,
                  wonPrizeText: wheelItemsDeals[selecteditem],
                  onCloseButton: () {
                    isCloseButtonTap.value = true;
                    Navigator.pop(context);
                  },
                );
              },
            );
          });
        });
      });
    });
  }

  void checkTimerAndSet() {
    String lastSpinTimeString = '';

    if (userController.hasUser.value) {
      lastSpinTimeString = userController.user.value.lastSpinDateTimeString!;
    } else {
      lastSpinTimeString = CookieManager.getCookie(kLastSpinTimekey);
    }

    if (lastSpinTimeString != '') {
      DateTime previousLastSpinTime = DateTime.parse(lastSpinTimeString);

      lastSpinTime = previousLastSpinTime;
      // Checking has same year or not
      if (lastSpinTime.year == DateTime.now().year &&
          lastSpinTime.month == DateTime.now().month) {
        // Checking same day or not
        if (lastSpinTime.day == DateTime.now().day ||
            lastSpinTime.add(4.hours).day == DateTime.now().day) {
          if ((lastSpinTime.hour + 4) - DateTime.now().hour > 0) {
            isCloseButtonTap.value = true;
            haveToShowClickAnimation = false;
          } else {
            // show spin
          }
        } else {
          // show spin
        }
      }
    }

    // print('lastSpinTimeString $lastSpinTimeString');
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
