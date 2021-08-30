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
    return Scaffold();
  }
}
