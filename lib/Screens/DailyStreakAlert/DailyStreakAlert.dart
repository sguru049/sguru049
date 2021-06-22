import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Utilities/BorderText/BorderText.dart';
import 'package:flutter/material.dart';

class DailyStreakAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          overflow: Overflow.visible,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      height: min(MediaQuery.of(context).size.width * .8, 350),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(9, (index) {
                          return DailyStreakItem(
                            dayCount: index + 1,
                            selectedIndex: 7,
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Come back everyday for new reward',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: MaterialButton(
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
                            child: AutoSizeText('View ad to recover streak',
                                maxLines: 1,
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow.shade400,
                                )),
                          ),
                        ),
                        onPressed: () {},
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
  }) : super(key: key);
  final int dayCount;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(
                    'Day $dayCount',
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
              ' +${dayCount * 100} ',
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
