import 'dart:math';
import 'package:animated_rotation/animated_rotation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Screens/FortuneWheel/FortuneWheelController.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';

class FortuneWheelScreen extends StatelessWidget {
  final FortuneWheelScreenController controller =
      Get.put(FortuneWheelScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(icBottomSprincle, fit: BoxFit.fill),
        ),
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(icSprinkle, fit: BoxFit.fill),
                  ),
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
                                angle: pi * 2 * 0.23,
                                child: AnimatedRotation(
                                  angle: controller.rotationValue.value,
                                  duration: controller.rotationDuration,
                                  child: FortuneWheel(
                                    selected: controller.fortuneStream,
                                    items: controller.wheelItems,
                                    animateFirst: false,
                                    duration: 5.seconds,
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
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          width: 70,
                          height: 70,
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
                                  margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3.5, color: cWhiteColor),
                                    borderRadius: BorderRadius.circular(30),
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
                        if (!controller.isStreamActive) controller.onSpin();
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: MaterialButton(
                          child: Text(
                            controller.wheelScreenOptions[index].name,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            // TODO :
                          }),
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 0.5,
                        color: cMediumGrayColor,
                      ),
                  itemCount: controller.wheelScreenOptions.length),
            )
          ],
        ),
      ]),
    );
  }
}
