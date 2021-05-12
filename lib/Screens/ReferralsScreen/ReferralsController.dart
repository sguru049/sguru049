import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReferralsController extends GetxController {
  String msg = 'My referrals message with code';
  String referralCode = 'Referral Code';
  TextEditingController referralCodeController = TextEditingController();
  @override
  void onReady() {
    referralCodeController.text = referralCode;
    super.onReady();
  }
}
