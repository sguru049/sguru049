import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sOops, style: TextStyle(color: Colors.black26, fontSize: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_off, color: cMediumGrayColor),
                Text(
                  sInternetNotAvilable,
                  style: TextStyle(color: cMediumGrayColor, fontSize: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
