import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'RewardsController.dart';

/// This screen is used for avail offer
///

class RewardsReedemScreen extends StatelessWidget {
  static const routeName = '/mycoupons/:qrcode';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => RewardsReedemScreen.create(),
      title: 'home',
      transition: Transition.cupertino);

  static create() =>
      RewardsReedemScreen(controller: Get.put(RewardsController()));

  final RewardsController controller;
  const RewardsReedemScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: MaterialButton(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.amber),
                borderRadius: BorderRadius.circular(100),
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.pink.shade900,
                //     cAppThemeColor,
                //     Colors.pink.shade900,
                //   ],
                // ),
                color: cAppThemeColor,
                boxShadow: [
                  BoxShadow(color: cAppThemeColor, blurRadius: 5.0),
                ]),
            child: Obx(() {
              return Text(controller.isOfferAvailed.value
                  ? 'Offer Availed'
                  : 'Avail offer');
            }),
          ),
          onPressed: () {
            controller.reedemCoupon();
          },
        ),
      ),
    );
  }
}
