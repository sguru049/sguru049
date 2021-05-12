import 'dart:math';
import 'package:botox_deals/Assets/DataConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LogInSignUpScreenController.dart';
import 'PhoneLoginScreen/PhoneLoginAndSignupScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Utilities/AppTheme.dart';

class LogInSignUpScreen extends StatelessWidget {
  final LogInSignUpScreenController controller =
      Get.put(LogInSignUpScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset(icGoogleSigninBtn,
                width: min(400, MediaQuery.of(context).size.width / 2),
                fit: BoxFit.fill),
            onTap: () => _getGoogleProfile(context).show(),
            // onTap: () => controller.googleLoginHandler(),
          ),
          SizedBox(height: 20),
          GestureDetector(
              child: Image.asset(icPhoneSigninBtn,
                  width: min(400, MediaQuery.of(context).size.width / 2),
                  fit: BoxFit.fill),
              onTap: () => Get.toNamed(PhoneLoginAndSignupScreen.routeName)),
        ],
      )),
    );
  }

  Alert _getGoogleProfile(BuildContext context) {
    return Alert(
        onWillPopActive: true,
        style: AlertStyle(
            isCloseButton: false,
            titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor),
            descStyle: TextStyle(fontSize: 14, color: cDarkGrayColor)),
        context: context,
        title: sAlertTitle,
        desc: sAlertDesc,
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(0),
            child: AutoSizeText(
              sCancelButtonText,
              style: TextStyle(color: cWhiteColor, fontSize: kTitleFontSize),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          DialogButton(
              padding: EdgeInsets.all(0),
              child: AutoSizeText(
                sAllowButtonText,
                style: TextStyle(color: cWhiteColor, fontSize: kTitleFontSize),
              ),
              onPressed: () {
                controller.googleLoginHandler();
                Navigator.pop(context);
              })
        ]);
  }
}

// // Sample button
// //
// // SigninButton(
// //     icon: Container(
// //         padding: EdgeInsets.symmetric(horizontal: 20),
// //         child: Icon(Icons.phone, color: cAppThemeColor)),
// //     text: 'Login with Phone',
// //     onButtonTap: () {})
// // Sign in button
// class SigninButton extends StatelessWidget {
//   const SigninButton({
//     Key key,
//     @required this.icon,
//     @required this.text,
//     @required this.onButtonTap,
//   }) : super(key: key);
//   final Widget icon;
//   final String text;
//   final Function onButtonTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         child: Container(
//           width: MediaQuery.of(context).size.width / 2,
//           height: 50,
//           margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: cMediumGrayColor,
//                   spreadRadius: 1,
//                   blurRadius: 0.5,
//                   offset: Offset(0.0, 1.0))
//             ],
//             color: cSignUpScreenButtonColor,
//           ),
//           child: Row(
//             children: [
//               icon,
//               Text(text,
//                   maxLines: 1,
//                   style: TextStyle(
//                       color: cDarkGrayColor,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//         onTap: () => onButtonTap());
//   }
// }
