import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Utilities/BorderText/BorderText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'WalletScreenController.dart';

class WalletScreen extends StatelessWidget {
  static const routeName = '/home/user_wallet';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => WalletScreen.create(),
      title: 'Wallet',
      transition: Transition.cupertino);

  static create() =>
      WalletScreen(controller: Get.put(WalletScreenController()));

  final WalletScreenController controller;
  const WalletScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet'), centerTitle: true),
      body: Column(
        children: [
          // Balance View
          Expanded(
            flex: 2,
            child: Container(
              color: cWhiteColor,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  BorderedText(
                    child: AutoSizeText(
                      'Total Balance',
                      style: TextStyle(color: cWhiteColor, fontSize: 24),
                    ),
                    strokeWidth: 4.0,
                    strokeColor: Colors.black,
                  ),
                  Obx(() {
                    return AutoSizeText(
                      '${controller.accountBal} Beauty Coins',
                      style: TextStyle(color: cAppThemeColor, fontSize: 20),
                    );
                  }),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      MaterialButton(
                        onPressed: () {},
                        color: cAppThemeColor,
                        child: Text('Withdraw Beauty Coins'),
                      ),
                      Spacer(),
                      MaterialButton(
                        onPressed: () {
                          controller.addTransactions(10);
                        },
                        color: cAppThemeColor,
                        child: Text('Add Beauty Coins'),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          // Transactions
          Expanded(
            flex: 4,
            child: Obx(() {
              return controller.isGettingTransactions.value
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      child: ListView.builder(
                          itemCount: controller.transactions.length,
                          itemBuilder: (context, index) {
                            final data = controller.transactions[index];
                            return Column(children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                tileColor: cBackGroundColor,
                                title: Text(data.type == 0
                                    ? 'Deposit Beauty Coins'
                                    : 'Withdraw Beauty Coins'),
                                subtitle: Text(
                                    formattedDate(data.transactionOn.toDate())),
                                trailing: Text(
                                  (data.type == 0
                                      ? '+ ' + data.amount.toString()
                                      : '- ' + data.amount.toString()),
                                ),
                              ),
                              Container(height: 0.5, color: cDarkGrayColor),
                            ]);
                          }),
                      onRefresh: () {
                        return Future.delayed(0.1.seconds).then((value) {
                          controller.getAccountTransactions();
                        });
                      });
            }),
          )
        ],
      ),
    );
  }

  String formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
