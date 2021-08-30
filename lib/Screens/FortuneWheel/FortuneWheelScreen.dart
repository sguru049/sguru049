import 'dart:math';
import 'package:animated_rotation/animated_rotation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Screens/FortuneWheel/FortuneWheelController.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:beauty_spin/Utilities/BorderText/BorderText.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';

class FortuneWheelScreen extends StatelessWidget {
  final FortuneWheelScreenController controller =
      Get.put(FortuneWheelScreenController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Center(
              child: Stack(children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(context.width / 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(400),
                        border: Border.all(
                          width: 5,
                          color: cSpinBorderColor,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10)
                        ]),
                    child: Obx(() {
                      return Transform.rotate(
                        angle: pi * 2 * 0.25,
                        child: AnimatedRotation(
                          angle: controller.rotationValue.value,
                          duration: controller.rotationDuration,
                          child: FortuneWheel(
                            items: controller.wheelItems,
                            selected: controller.fortuneStream,
                            animateFirst: false,
                            indicators: [],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ]),
            ),
          ),
          //
          Positioned.fill(
            child: GestureDetector(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(left: (screenWidth > 500) ? 15 : 10),
                  alignment: Alignment.center,
                  width: screenWidth * (screenWidth > 600 ? 0.12 : 0.2),
                  height: screenWidth * (screenWidth > 600 ? 0.12 : 0.2),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          icSpinCenterLogo,
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ),
                      ),
                      Positioned.fill(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 60,
                          height: 55,
                          margin: EdgeInsets.fromLTRB(
                              0,
                              (screenWidth > 500) ? 7.5 : 5,
                              (screenWidth > 500) ? 15 : 10,
                              (screenWidth > 500) ? 7.5 : 5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 3.5, color: cWhiteColor),
                            borderRadius: BorderRadius.circular(200),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(70, 70, 70, 1),
                                Color.fromRGBO(120, 120, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            'SPIN',
                            style: kSpinTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                if (!controller.isStreamActive) controller.onSpin(context);
              },
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: Row(
                  children: [
                    // TODO CLick buttonwork
                    Expanded(
                      child: Obx(() {
                        return (controller.haveToShowClickAnimation)
                            ? AnimatedContainer(
                                alignment:
                                    controller.clickButtonAlignment.value,
                                duration: controller.clickAnimationDuration,
                                child: Image.asset(
                                  icArrow,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                ),
                              )
                            : SizedBox();
                      }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 50,
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Obx(() {
              return (controller.isCloseButtonTap.value)
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: AutoSizeText(
                                'Congratulation'.toUpperCase(),
                                maxLines: 1,
                                style: kArial.copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Colors.amber.shade900,
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.all(10),
                            child: Container(
                              width: screenWidth * 0.5 > 350
                                  ? 200
                                  : screenWidth * 0.44,
                              height: screenHeight * 0.5 > 400
                                  ? 50
                                  : screenHeight * 0.07,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.amber),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                        color: cAppThemeColor, blurRadius: 5.0),
                                  ]),
                              alignment: Alignment.center,
                              child: BorderedText(
                                child: AutoSizeText(
                                  'Spin Again!',
                                  maxLines: 1,
                                  style: kArial.copyWith(
                                      color: cWhiteColor, letterSpacing: 2),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: screenWidth * 0.5 > 350
                                    ? 300
                                    : screenWidth * 0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.amber),
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.pink.shade900,
                                      cAppThemeColor,
                                      Colors.pink.shade900,
                                    ],
                                  ),
                                  color: cAppDullThemeColor,
                                ),
                                child: CustomTimer(
                                  from: Duration(
                                    hours: ((controller.lastSpinTime.hour + 3) -
                                                DateTime.now().hour <
                                            0)
                                        ? 0
                                        : (controller.lastSpinTime.hour + 3) -
                                            DateTime.now().hour,
                                    minutes:
                                        ((controller.lastSpinTime.minute + 59) -
                                                    DateTime.now().minute <
                                                0)
                                            ? 0
                                            : (controller.lastSpinTime.minute +
                                                    59) -
                                                DateTime.now().minute,
                                    seconds:
                                        ((controller.lastSpinTime.second + 59) -
                                                    DateTime.now().second <
                                                0)
                                            ? 0
                                            : (controller.lastSpinTime.second +
                                                    59) -
                                                DateTime.now().second,
                                  ),
                                  to: Duration(hours: 0),
                                  onBuildAction: CustomTimerAction.auto_start,
                                  builder:
                                      (CustomTimerRemainingTime remaining) {
                                    if (remaining.hours == '00' &&
                                        remaining.minutes == '00' &&
                                        remaining.seconds == '00') {
                                      controller.isCloseButtonTap.value = false;
                                      controller.haveToShowClickAnimation =
                                          true;
                                    }

                                    return BorderedText(
                                      child: AutoSizeText(
                                        'Next Spin  ${remaining.hours}:${remaining.minutes}:${remaining.seconds}',
                                        maxLines: 1,
                                        style: kArial.copyWith(
                                          color: cWhiteColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox();
            }),
          )
        ],
      ),
    );
  }
}
