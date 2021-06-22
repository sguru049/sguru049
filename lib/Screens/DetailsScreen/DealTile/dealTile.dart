import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/DealsModel.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beauty_spin/Utilities/Toast/Toast.dart';

class DealTileWidget extends StatelessWidget {
  final DealModel deal;
  const DealTileWidget({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        color: cAppThemeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(deal.title!,
                style: TextStyle(
                    color: cWhiteColor,
                    fontSize: kButtonFontSize,
                    fontWeight: FontWeight.w500)),
          )),
          if (deal.code != null)
            GestureDetector(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(deal.code!, style: kWhiteTextTheme),
                  )),
              onTap: () {
                Clipboard.setData(ClipboardData(text: deal.code));
                showToast(context, sCodeCopied, gravity: Toast.bottom);
              },
            )
        ],
      ),
    );
  }

  // Toast
  void showToast(BuildContext context, String msg,
      {int duration = 2, int? gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
