import 'dart:math';
import 'package:get/get.dart';
import 'ReferralsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:botox_deals/Assets/DataConstants.dart';
import 'package:botox_deals/Utilities/Toast/Toast.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';

class Referrals extends StatelessWidget {
  static const routeName = '/referral';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => Referrals.create(),
      title: 'referral',
      transition: Transition.cupertino);

  static create() => Referrals(controller: Get.put(ReferralsController()));

  final ReferralsController? controller;
  const Referrals({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(sReferScreenTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Refer Image
            Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                width: min(MediaQuery.of(context).size.width, 500),
                child: Image.asset(icRefer)),
            _buildTitleAndDesc(context),
            _buildReferralCode(context),
            _buildShare(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndDesc(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            sReferInviteTitle,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          AutoSizeText(
            sReferInviteDesc,
            style: TextStyle(
              color: cDarkGrayColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCode(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width / 2,
      child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          color: cDarkGrayColor,
          strokeWidth: 2,
          dashPattern: const <double>[5, 3],
          child: TextField(
            textAlign: TextAlign.center,
            controller: controller!.referralCodeController,
            readOnly: true,
            decoration: new InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.copy, color: cAppThemeColor),
                splashRadius: 20,
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: controller!.referralCode));
                  showToast(context, sCodeCopied, gravity: Toast.bottom);
                },
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          )),
    );
  }

  Widget _buildShare(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(flex: 2),
        GestureDetector(
          child: Container(
              child: Image.asset(icWhatsappIconImage), width: 40, height: 40),
          onTap: () async {
            await launch(
                'https://api.whatsapp.com/send?text=${controller!.msg}');
          },
        ),
        Spacer(),
        Container(color: cAppThemeColor, width: 2, height: 80),
        Spacer(),
        GestureDetector(
          child: Container(
              child: Image.asset(icMessageImage), width: 40, height: 40),
          onTap: () {
            sendSMS(message: controller!.msg, recipients: ['']);
          },
        ),
        Spacer(flex: 2),
      ],
    );
  }

  // Toast
  void showToast(BuildContext context, String msg,
      {int duration = 2, int? gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
