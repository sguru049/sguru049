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
      body: Center(),
    );
  }
}
