import 'package:auto_size_text/auto_size_text.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Screens/LoginScreen/LogInSignUpScreenController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum InputType { PhoneNo, VerificationCode }

class PhoneLoginAndSignupScreen extends StatelessWidget {
  static const routeName = '/home/number_signup';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => PhoneLoginAndSignupScreen.create(),
      title: 'Login with phone no',
      transition: Transition.cupertino);

  final LogInSignUpScreenController controller;

  static create() => PhoneLoginAndSignupScreen(
      controller: Get.put(LogInSignUpScreenController()));
  const PhoneLoginAndSignupScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(sPhoneSignUpScreenTitle, style: GoogleFonts.comfortaa()),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () {
      //       controller.emptyControllers();
      //       Get.back();
      //     },
      //   ),
      // ),
      body: Obx(() {
        return Center(
            child: controller.showLoader.value
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      // Title
                      Padding(
                        padding: EdgeInsets.all(20),
                        // alignment: Alignment.center,
                        child: Text(controller.userController.isNoEntered.value
                            ? sPhoneVerifTitle
                            : sPhoneVerifDesc),
                      ),
                      // Desc
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          controller.userController.isNoEntered.value
                              ? 'Enter the code sent to ${controller.userController.phoneNumberController.text}'
                              : sSentOtpDesc,
                          style: TextStyle(color: cDarkGrayColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Text Fields
                      (controller.userController.isNoEntered.value)
                          ? _buildPinCodeTextField(context)
                          : _buildPhoneNoTextField(context),
                      // Resend Button
                      _buildResend(context),
                      _buildDoneButton(context),
                    ],
                  ));
      }),
    );
  }

  Widget _buildPhoneNoTextField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: sEnterPhoneNo,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: cAppThemeColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: cAppThemeColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: cAppThemeColor),
          ),
        ),
        controller: controller.userController.phoneNumberController,
        focusNode: controller.userController.phoneNumberFocusNode,
        inputFormatters: [PhoneInputFormatter()],
        onChanged: (value) => controller.onPhoneNoTextChanged(value),
      ),
    );
  }

  Widget _buildPinCodeTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: PinCodeTextField(
          appContext: context,
          length: 6,
          controller: controller.userController.otpController,
          focusNode: controller.userController.otpFocusNode,
          blinkWhenObscuring: true,
          keyboardType: TextInputType.number,
          animationDuration: Duration(milliseconds: 300),
          pastedTextStyle: TextStyle(
            color: cAppThemeColor,
            fontWeight: FontWeight.bold,
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            fieldWidth: 30,
            fieldHeight: 40,
            selectedColor: cAppThemeColor,
            inactiveColor: cAppThemeColor,
            activeColor: cAppThemeColor,
          ),
          onChanged: (value) {}),
    );
  }

  Widget _buildResend(BuildContext context) {
    return (controller.userController.isNoEntered.value)
        ? Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                sDidntGetCode,
                style: TextStyle(color: cDarkGrayColor),
              ),
              TextButton(
                child: Text(sResend,
                    style: TextStyle(
                      color: cAppThemeColor,
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () {
                  controller.resendOtp();
                },
              )
            ]),
          )
        : SizedBox(height: 20);
  }

  Widget _buildDoneButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.center,
        height: 36,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36 / 2),
          border: Border.all(width: 2, color: cAppThemeColor),
          color: cAppThemeColor,
        ),
        child: AutoSizeText(
          (controller.userController.isNoEntered.value) ? sDone : sNext,
          maxLines: 1,
          style: (TextStyle(color: cWhiteColor)),
        ),
      ),
      onTap: () {
        if (controller.userController.isNoEntered.value) {
          controller.verifyPhoneAndGetUser();
        } else {
          controller.nextButtonTapped();
        }
      },
    );
  }
}
