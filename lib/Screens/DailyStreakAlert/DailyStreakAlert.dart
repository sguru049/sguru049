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
  const DailyStreakAlert({
    Key? key,
    required this.onClaim,
    required this.currentPosition,
    required this.dailyPrizeMultiplier,
    required this.currentUserStreakValue,
  }) : assert(currentPosition is CurrentStreakPostion);

  Widget build(BuildContext context) {
    final double width = min(75, MediaQuery.of(context).size.width * 0.3);
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
                padding: const EdgeInsets.fromLTRB(10, 36, 10, 10),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * .7,
                        height: 125,
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
                        height: 125,
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
                      height: 125,
                      padding: EdgeInsets.all(10),
                      child: DailyStreakItem(
                          dayCount: (currentUserStreakValue >= 7)
                              ? currentUserStreakValue
                              : 7,
                          selectedIndex: currentPosition.index + 1,
                          prizeMultiplier: dailyPrizeMultiplier),
                    ),
                    Text(
                      'Come back everyday for new reward',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Claim button tapped
                    Center(
                      child: MaterialButton(
                        onPressed: () => onClaim(),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          alignment: Alignment.center,
                          height: 36,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36 / 2),
                            border: Border.all(width: 2, color: cAppThemeColor),
                            color: cAppThemeColor,
                          ),
                          child: AutoSizeText(
                            'Claim',
                            maxLines: 1,
                            style: (TextStyle(color: cWhiteColor)),
                          ),
                        ),
                      ),
                    )
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
      child: Column(
        children: [
          SizedBox(height: 4),
          Center(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (selectedIndex == dayCount)
                  ? Colors.teal.shade200
                  : cAppDullThemeColor,
            ),
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
          Spacer(),
          Container(
            alignment: Alignment.center,
            height: 30,
            child: Image.asset(
              icCoins,
              fit: BoxFit.fitHeight,
            ),
          ),
          Spacer(),
          SizedBox(height: 4),
          Center(
              child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: (selectedIndex == dayCount)
                  ? Colors.teal.shade200
                  : cAppDullThemeColor,
            ),
            child: AutoSizeText(
              ' +${dayCount * prizeMultiplier} ',
              minFontSize: 8,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
