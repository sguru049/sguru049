import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

/// This screen is used for scanning showing qr code
///
class RewardQrScreen extends StatelessWidget {
  final String qrcode;
  const RewardQrScreen({Key? key, required this.qrcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
          child: BarcodeWidget(
            data: qrcode,
            barcode: Barcode.qrCode(),
          ),
        ),
      ),
    );
  }
}
