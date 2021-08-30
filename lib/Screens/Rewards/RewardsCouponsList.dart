import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'RewardsController.dart';

class RewardsCouponsListScreen extends StatelessWidget {
  static const routeName = '/home/mycoupons';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => RewardsCouponsListScreen.create(),
      title: 'home',
      transition: Transition.cupertino);

  static create() =>
      RewardsCouponsListScreen(controller: Get.put(RewardsController()));

  final RewardsController controller;
  const RewardsCouponsListScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rewards')),
      body: Obx(() {
        return controller.isGettingCoupons.value
            ? Center(child: CircularProgressIndicator(color: cAppThemeColor))
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      children: [],
                    ),
                  )
                ],
              );
      }),
    );
  }
}

class RewardsScreenTopBarListButton extends StatelessWidget {
  final RewardsController controller = Get.find();
  final String title;
  RewardsScreenTopBarListButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          child: Text(title),
        ),
        onTap: () => controller.onRewardListTypeChange(title),
      ),
    );
  }
}
