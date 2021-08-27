import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';

class YouWonAlert extends StatelessWidget {
  const YouWonAlert({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.wonPrizeText,
  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final String wonPrizeText;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: screenWidth * 0.5 > 300 ? 300 : screenWidth * 0.8,
        height: screenHeight * 0.5,
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
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenWidth * 0.5 > 300 ? 300 : screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  color: cAppThemeColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: Colors.amber,
                          child: Text(
                            'You Won!\n \n$wonPrizeText',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
