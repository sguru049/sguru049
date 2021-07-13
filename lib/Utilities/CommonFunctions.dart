import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AppTheme.dart';

class CommonFunctions {
  static onClaimIfUserNotLoggedIn(BuildContext context) {
    final HomeScreenController controller = Get.find();
    Alert(
      context: context,
      title: sLoginToAvailOffer,
      onWillPopActive: true,
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor),
          descStyle: TextStyle(fontSize: 14, color: cAppThemeColor)),
      buttons: [
        DialogButton(
            child: Text(sCancel, style: kWhiteTextTheme.copyWith(fontSize: 14)),
            onPressed: () {
              // Navigator.pop(context);
              Get.back();
              Alert(
                context: context,
                title: sYouSure,
                desc: sLooseThisOffer,
                style: AlertStyle(
                    isCloseButton: false,
                    titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor),
                    descStyle: TextStyle(fontSize: 14, color: cAppThemeColor)),
                buttons: [
                  DialogButton(
                      child: Text(sCancel,
                          style: kWhiteTextTheme.copyWith(fontSize: 14)),
                      onPressed: () {
                        controller.currentNavigationBarIndex.value = 3;
                        Navigator.pop(context);
                      }),
                  DialogButton(
                      child: Text(sOk,
                          style: kWhiteTextTheme.copyWith(fontSize: 14)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ).show();
            }),
        DialogButton(
            child: Text(sOk, style: kWhiteTextTheme.copyWith(fontSize: 14)),
            onPressed: () {
              Get.back();
              controller.currentNavigationBarIndex.value = 3;
              // Navigator.pop(context);
            }),
      ],
    ).show();
  }
}
