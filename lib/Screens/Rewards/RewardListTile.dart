import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/CouponModel.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreenController.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'RewardQr.dart';

/// This is reedem list tile
class RewardListTile extends StatelessWidget {
  final CouponModel data;
  const RewardListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: max(90, (MediaQuery.of(context).size.height / 7)),
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cWhiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: max(70, (MediaQuery.of(context).size.height / 7) - 20),
              height: max(70, (MediaQuery.of(context).size.height / 7) - 20),
              margin: EdgeInsets.only(right: 20),
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: 'www.BeautySpin.app',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(data.title!,
                        maxFontSize: kBoldFontSize,
                        style: TextStyle(fontWeight: FontWeight.w900),
                        maxLines: 1),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                        (data.validTill != null)
                            ? 'Expired on : ${data.validTill!.toDate().day}/${data.validTill!.toDate().month}/${data.validTill!.toDate().year}'
                            : 'Expired on : ----',
                        maxFontSize: 14.0,
                        style: TextStyle(color: cDarkGrayColor),
                        maxLines: 1),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        if (CookieManager.isUserLoggedIn()) {
          if (data.status == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RewardQrScreen(qrcode: data.qrCode!),
              ),
            );
          }
        } else {
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
                    child: Text(sCancel,
                        style: kWhiteTextTheme.copyWith(fontSize: 14)),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                DialogButton(
                    child: Text(sOk,
                        style: kWhiteTextTheme.copyWith(fontSize: 14)),
                    onPressed: () {
                      Navigator.pop(context);
                      HomeScreenController controller = Get.find();
                      controller.currentNavigationBarIndex.value = 3;
                      // Navigator.pop(context);
                    }),
              ]).show();
        }
      },
    );
  }
}
