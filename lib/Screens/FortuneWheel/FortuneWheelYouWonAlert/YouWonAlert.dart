import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:beauty_spin/Utilities/BorderText/BorderText.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';

class YouWonAlert extends StatelessWidget {
  const YouWonAlert({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.wonPrizeText,
    required this.onCloseButton,
  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final String wonPrizeText;
  final Function onCloseButton;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: screenWidth * 0.5 > 350 ? 350 : screenWidth * 0.8,
        height: screenHeight * 0.5 > 400 ? 250 : screenHeight * 0.5,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -(screenHeight * 0.1),
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
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenWidth * 0.5 > 350 ? 350 : screenWidth * 0.8,
                  height: screenHeight * 0.5 > 400 ? 250 : screenHeight * 0.4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.shade900,
                        cAppThemeColor,
                        Colors.pink.shade900,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(6),
                              alignment: Alignment.center,
                              color: Colors.amber,
                              child: Image.asset(
                                icShine,
                                fit: BoxFit.fill,
                                width: screenWidth * 0.5 > 350
                                    ? 350
                                    : screenWidth * 0.8,
                                height: screenHeight * 0.5 > 400
                                    ? 180
                                    : screenHeight * 0.3,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(6),
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomLeft,
                                  child: Image.asset(
                                    icGift,
                                    width: screenWidth * 0.5 > 350
                                        ? 80
                                        : screenWidth * 0.2,
                                    height: screenHeight * 0.15,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(6),
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 40, 10),
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      'You Won!\n$wonPrizeText',
                                      maxLines: 3,
                                      style: kArial.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Center(
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
                              // Stack(
                              //   clipBehavior: Clip.none,
                              //   children: [
                              //     Center(
                              //       child:
                              // Text('spin Again!'),
                              // ),
                              // Positioned(
                              //   top: -10,
                              //   right: -10,
                              //   child: Container(
                              //     padding: EdgeInsets.all(4),
                              //     decoration: BoxDecoration(
                              //       color: cRedColor,
                              //       border: Border.all(
                              //           width: 2, color: cWhiteColor),
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     child: Icon(
                              //       Icons.add_alert,
                              //       size: 15,
                              //     ),
                              //   ),
                              // )
                              //   ],
                              // ),
                            ),
                          ),
                          onTap: () {
                            // TODO : ON TAP OF SPIN AGAIN
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: cRedColor,
                  border: Border.all(width: 2, color: cWhiteColor),
                ),
                child: GestureDetector(
                  child: Icon(Icons.close, size: 20, color: Colors.white),
                  onTap: () => onCloseButton(),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.5 > 400
                  ? -(screenHeight * 0.08)
                  : -(screenHeight * 0.05),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: screenWidth * 0.5 > 350 ? 300 : screenWidth * 0.7,
                  height: 50,
                  decoration: BoxDecoration(
                    // border:
                    //     Border.all(width: 4, color: Colors.amber),
                    // borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 4)],
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
                    from: Duration(hours: 4),
                    to: Duration(hours: 0),
                    onBuildAction: CustomTimerAction.auto_start,
                    builder: (CustomTimerRemainingTime remaining) {
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
            ),
          ],
        ),
      ),
    );
  }
}
