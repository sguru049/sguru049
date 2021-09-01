import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Screens/Rewards/RewardListTile.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
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
      // appBar: AppBar(title: Text('Rewards')),
      backgroundColor: cBackGroundColor,
      body: Obx(() {
        return controller.isGettingCoupons.value
            ? Center(child: CircularProgressIndicator(color: cAppThemeColor))
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        RewardsScreenTopBarListButton(title: sAvailable),
                        RewardsScreenTopBarListButton(title: sUsed),
                        RewardsScreenTopBarListButton(title: sExpired),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.coupons.length == 0
                        ? Center(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              child: AutoSizeText(
                                'No\n${RewardsListTypeFunctions.getStringValue(controller.selectedList.value)}\nRewards',
                                maxLines: 3,
                                style: kArial.copyWith(
                                    color: cLightGrayColor, fontSize: 40),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return RewardListTile(
                                    data: controller.coupons[index]);
                              },
                              itemCount: controller.coupons.length,
                            ),
                            onRefresh: () {
                              controller.getCoupons();
                              return Future.delayed(300.milliseconds);
                            }),
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
        child: Obx(() {
          bool isSelected =
              RewardsListTypeFunctions.getRewardsListType(title) ==
                  controller.selectedList.value;
          return AnimatedContainer(
            duration: 300.milliseconds,
            curve: Curves.easeInOut,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cWhiteColor,
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? cAppThemeColor : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: AutoSizeText(
              title,
              minFontSize: 10,
              style: TextStyle(
                color: isSelected ? cAppThemeColor : cDarkGrayColor,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          );
        }),
        onTap: () => controller.onRewardListTypeChange(title),
      ),
    );
  }
}
