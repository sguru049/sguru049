import 'dart:html';
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';

enum CurrentStreakPostion {
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh
}

class DailyStreakAlert extends StatelessWidget {
  final Function onClaim;
  final CurrentStreakPostion currentPosition;
  final int dailyPrizeMultiplier;
  final int currentUserStreakValue;
  final bool isLoogedIn;

  const DailyStreakAlert({
    Key? key,
    required this.onClaim,
    required this.currentPosition,
    required this.dailyPrizeMultiplier,
    required this.currentUserStreakValue,
    required this.isLoogedIn,
  }) : assert(currentPosition is CurrentStreakPostion);

  Widget build(BuildContext context) {
    final double width = min(75, MediaQuery.of(context).size.width * 0.2);
    print(MediaQuery.of(context).size.width);
    final blackBorderColor = Colors.black54;
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: blackBorderColor, width: 5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: blackBorderColor,
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ],
                  color: cAppDullThemeColor),
              height: min(MediaQuery.of(context).size.height * .8, 500),
              width: min(MediaQuery.of(context).size.width * .8, 400),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 36, 8, 8),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * .7,
                        height: 104,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 1,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 2,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 3,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .7,
                        height: 104,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 4,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 5,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                            DailyStreakItem(
                              dayCount: 6,
                              selectedIndex: currentPosition.index + 1,
                              prizeMultiplier: dailyPrizeMultiplier,
                              width: width,
                            ),
                            Spacer(),
                          ],
                        )),

                    Container(
                      width: 200,
                      height: 104,
                      padding: EdgeInsets.all(10),
                      child: DailyStreakItem(
                          dayCount: (currentUserStreakValue >= 7)
                              ? currentUserStreakValue
                              : 7,
                          selectedIndex: currentPosition.index + 1,
                          prizeMultiplier: dailyPrizeMultiplier),
                    ),
                    Spacer(),
                    // Claim button tapped
                    Center(
                      child: MaterialButton(
                        onPressed: () => onClaim(),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          alignment: Alignment.center,
                          height: 36,
                          width: isLoogedIn ? 100 : 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36 / 2),
                            border: Border.all(width: 2, color: cAppThemeColor),
                            color: cAppThemeColor,
                          ),
                          child: AutoSizeText(
                            isLoogedIn ? 'Claim' : 'Login to Claim',
                            maxLines: 1,
                            style: (TextStyle(color: cWhiteColor)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Login Later',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: cAppThemeColor,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    Spacer(),
                    AutoSizeText(
                      'Come back everyday for new reward',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -20,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: blackBorderColor, width: 2.5),
                      borderRadius: BorderRadius.circular(10),
                      color: cAppDullThemeColor,
                      boxShadow: [
                        BoxShadow(
                          color: blackBorderColor,
                          blurRadius: 2,
                          spreadRadius: 1,
                        )
                      ]),
                  padding: EdgeInsets.all(10),
                  child: AutoSizeText(
                    '    Daily Bonus    ',
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )),
          ],
        ));
  }
}

class DailyStreakItem extends StatelessWidget {
  const DailyStreakItem({
    Key? key,
    required this.dayCount,
    required this.selectedIndex,
    required this.prizeMultiplier,
    this.width,
  }) : super(key: key);
  final int dayCount;
  final int selectedIndex;
  final int prizeMultiplier;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(10),
          color: (selectedIndex == dayCount)
              ? Colors.teal.shade200
              : cAppDullThemeColor,
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  icCoins,
                  height: 50,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            // // Center(
            //   child:
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: width,
                child: AutoSizeText(
                  ' +${dayCount * prizeMultiplier} ',
                  minFontSize: 8,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // ),
            Positioned.fill(
              child: Column(
                children: [
                  Center(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            'Day $dayCount',
                            minFontSize: 8,
                            maxLines: 1,
                          ),
                        ]),
                  )),
                  SizedBox(height: 4),
                ],
              ),
            )
          ],
        ));
  }
}
