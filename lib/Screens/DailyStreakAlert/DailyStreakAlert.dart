import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Utilities/BorderText/BorderText.dart';
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
  const DailyStreakAlert({
    Key? key,
    required this.onClaim,
    required this.currentPosition,
    required this.dailyPrizeMultiplier,
  }) : assert(currentPosition is CurrentStreakPostion);

  Widget build(BuildContext context) {
    final double width = min(75, MediaQuery.of(context).size.width * 0.3);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          // overflow: Overflow.visible,
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2.5),
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [cAppThemeColor, cPinkColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: min(MediaQuery.of(context).size.height * .8, 500),
              width: min(MediaQuery.of(context).size.width * .8, 400),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width * .7,
                    //   height: 240,
                    //   child: GridView.count(
                    //     crossAxisCount: 3,
                    //     crossAxisSpacing: 10,
                    //     mainAxisSpacing: 10,
                    //     children: List.generate(6, (index) {
                    //       return DailyStreakItem(
                    //           dayCount: index + 1,
                    //           selectedIndex: currentPosition.index + 1,
                    //           prizeMultiplier: dailyPrizeMultiplier);
                    //     }),
                    //   ),
                    // ),

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
                          dayCount: 7,
                          selectedIndex: currentPosition.index + 1,
                          prizeMultiplier: dailyPrizeMultiplier),
                    ),
                    Text(
                      'Come back everyday for new reward',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Claim button tapped
                    Center(
                      child: MaterialButton(
                        onPressed: () => onClaim(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: cPinkColor,
                              border:
                                  Border.all(color: Colors.yellow, width: 2.5),
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [cAppThemeColor, cPinkColor],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.yellow,
                                    blurRadius: 2,
                                    spreadRadius: 1)
                              ]),
                          padding: EdgeInsets.all(10),
                          child: BorderedText(
                            strokeWidth: 4.0,
                            strokeColor: Colors.black,
                            child: AutoSizeText('Claim',
                                maxLines: 1,
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow.shade400,
                                )),
                          ),
                        ),
                      ),
                    )
                    // // ads button
                    // Center(
                    //   child: MaterialButton(
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           color: cPinkColor,
                    //           border:
                    //               Border.all(color: Colors.yellow, width: 2.5),
                    //           borderRadius: BorderRadius.circular(10),
                    //           gradient: LinearGradient(
                    //             colors: [cAppThemeColor, cPinkColor],
                    //             begin: Alignment.bottomCenter,
                    //             end: Alignment.topCenter,
                    //           ),
                    //           boxShadow: [
                    //             BoxShadow(
                    //                 color: Colors.yellow,
                    //                 blurRadius: 2,
                    //                 spreadRadius: 1)
                    //           ]),
                    //       padding: EdgeInsets.all(10),
                    //       child: BorderedText(
                    //         strokeWidth: 4.0,
                    //         strokeColor: Colors.black,
                    //         child: AutoSizeText('View ad to recover streak',
                    //             maxLines: 1,
                    //             style: TextStyle(
                    //               letterSpacing: 1.5,
                    //               fontWeight: FontWeight.w600,
                    //               color: Colors.yellow.shade400,
                    //             )),
                    //       ),
                    //     ),
                    //     onPressed: () {},
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -20,
              child: Container(
                  decoration: BoxDecoration(
                      color: cPinkColor,
                      border: Border.all(color: Colors.yellow, width: 2.5),
                      gradient: LinearGradient(
                        colors: [cAppThemeColor, cPinkColor],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.yellow,
                            blurRadius: 2,
                            spreadRadius: 1)
                      ]),
                  padding: EdgeInsets.all(10),
                  child: BorderedText(
                    strokeWidth: 4.0,
                    strokeColor: Colors.black,
                    child: AutoSizeText(
                      'Daily Bonus',
                      maxLines: 1,
                      style: TextStyle(
                        letterSpacing: 2.5,
                        color: Colors.yellow.shade400,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )),
            ),
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
        border: Border.all(color: Colors.yellow, width: 2.5),
        borderRadius: BorderRadius.circular(10),
        color: (selectedIndex == dayCount) ? Colors.teal : Colors.transparent,
      ),
      child: Column(
        children: [
          SizedBox(height: 4),
          Center(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  colors: (selectedIndex == dayCount)
                      ? [Colors.teal.shade200, Colors.teal]
                      : [cAppThemeColor, cPinkColor],
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Day $dayCount',
                    minFontSize: 8,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                )
              ],
              gradient: LinearGradient(
                colors: (selectedIndex == dayCount)
                    ? [Colors.teal.shade200, Colors.teal]
                    : [cAppThemeColor, cPinkColor],
                end: Alignment.centerLeft,
                begin: Alignment.centerRight,
              ),
            ),
            child: AutoSizeText(
              ' +${dayCount * prizeMultiplier} ',
              minFontSize: 8,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
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
