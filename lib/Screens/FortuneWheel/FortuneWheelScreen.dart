import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Screens/DailyStreakAlert/DailyStreakAlert.dart';
import 'package:beauty_spin/Screens/FortuneWheel/FortuneWheelController.dart';
import 'package:beauty_spin/Services/HtmlEmbed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';

class FortuneWheelScreen extends StatelessWidget {
  final FortuneWheelScreenController controller =
      Get.put(FortuneWheelScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Forutne Wheel')),
      // body: HtmlEmbed().getHtmlPage(controller.htmlId, (int id) {
      //   return controller.iFrame
      //     ..width = MediaQuery.of(context).size.width.toString()
      //     ..height = MediaQuery.of(context).size.height.toString()
      //     ..src = 'http://localhost:8080/spinwheel/'
      //     ..onChange.listen((event) {
      //       print('onChange');
      //       print(event);
      //     })
      //     ..onClick.listen((event) {
      //       print('onClick');
      //       print(event);
      //     })
      //     ..onInput.listen((event) {
      //       print('onInput');
      //       print(event);
      //     })
      //     ..onError.listen((event) {
      //       print('onError');
      //       print(event);
      //     })
      //     ..onLoadedData.listen((event) {
      //       print('onLoadedData');
      //       print(event);
      //     })
      //     ..style.border = 'none';
      // }),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(icSprinkle, fit: BoxFit.fill),
                ),
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.all(context.width / 10),
                    child: Center(
                      child: FortuneWheel(
                        items: controller.wheelItems,
                        // animateFirst: false,
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   left: 20,
                //   right: 20,
                //   top: 10,
                //   child: Row(
                //     children: [
                //       AutoSizeText(
                //         'Spin and Win',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w600,
                //           backgroundColor: Colors.white.withOpacity(0.6),
                //         ),
                //       ),
                //       Spacer(),
                //       IconButton(
                //           icon: Icon(
                //             Icons.close,
                //           ),
                //           onPressed: () {}),
                //     ],
                //   ),
                // ),
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
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         content: Container(
                            //           height: context.height / 2,
                            //           child: Text('Daily Bonus'),
                            //         ),
                            //       );
                            //     });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DailyStreakAlert();
                                });
                          }),
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 0.5,
                        color: cMediumGrayColor,
                      ),
                  itemCount: controller.wheelScreenOptions.length))
        ],
      ),
    );
  }
}
