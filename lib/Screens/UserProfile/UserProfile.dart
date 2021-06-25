import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreenController.dart';
import 'package:beauty_spin/Screens/LoginScreen/PhoneLoginScreen/PhoneLoginAndSignupScreen.dart';
import 'package:beauty_spin/Screens/OfflineScreen/OfflineScreen.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:beauty_spin/Screens/UserProfile/WalletScreen/WalletScreen.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:beauty_spin/Utilities/Toast/Toast.dart';
// import 'package:botox_deals/Screens/LoginScreen/LogInSignUpScreen.dart';

class UserProfileScreen extends StatelessWidget {
  final UserProfileScreenController controller =
      Get.put(UserProfileScreenController());
  UserProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConnectivityBuilder(builder: (context, isConnected, status) {
        return (!isConnected!)
            ? OfflineScreen()
            : Obx(() {
                if (controller.showToast.value) {
                  showToast(context, sOnSuccesfullyLoginText,
                      gravity: Toast.bottom);
                }
                return Center(
                    child: (!controller.hasUser.value)
                        // ? LogInSignUpScreen()
                        ? PhoneLoginAndSignupScreen.create()
                        : (!controller.hasUserName.value)
                            ? enterNamePage(context)
                            : getProfilePage(context));
              });
      }),
    );
  }

  Widget enterNamePage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Text(sEnterNameScreenTitle),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            sEnterNameScreenDesc,
            style: TextStyle(color: cDarkGrayColor),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: sEnterName,
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
            controller: controller.nameController,
            focusNode: controller.nameFocusNode,
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
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
                sDone,
                maxLines: 1,
                style: (TextStyle(color: cWhiteColor)),
              ),
            ),
            onTap: () {
              controller.enterNameScreenDoneButtonTapped();
              if (controller.nameController.text.length >= 4) {
                Future.delayed(3.seconds).then((value) {
                  showToast(context, sOnSetupNameText, gravity: Toast.bottom);
                });
              }
            }),
      ],
    );
  }

  Widget getProfilePage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: cAppThemeColor),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: cAppThemeColor,
                  blurRadius: 1,
                )
              ],
            ),
            margin: EdgeInsets.all(20),
            child: (controller.user.value.photoUrl == null)
                ? buildImageOnError(context)
                : ClipOval(
                    child: Image.network(
                    controller.user.value.photoUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        buildImageOnError(context),
                  )),
          ),
          onTap: () => Get.toNamed(WalletScreen.routeName, arguments: {
            'accountBal': controller.user.value.accountBal!.value,
            'docId': controller.user.value.walletId,
          }),
        ),
        AutoSizeText(controller.user.value.name!,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10),
        AutoSizeText(
            (controller.user.value.email == null)
                ? controller.user.value.phoneNo!
                : controller.user.value.email!,
            textAlign: TextAlign.center),
        Spacer(),
        GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
              child: AutoSizeText(sLogOut,
                  style: TextStyle(color: cWhiteColor, fontSize: 14)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: cAppThemeColor),
            ),
            onTap: () {
              Alert(
                  context: context,
                  title: sLogoutAlertTitle,
                  desc: sLogoutAlertDesc,
                  style: AlertStyle(
                      titleStyle: TextStyle(
                          fontSize: 20,
                          color: cAppThemeColor,
                          fontWeight: FontWeight.w600)),
                  buttons: [
                    DialogButton(
                        child: Text(sYes,
                            style: TextStyle(color: cWhiteColor, fontSize: 14)),
                        onPressed: () {
                          controller.revertToGuestSession();
                          controller.googleSignIn.signOut();
                          final HomeScreenController homeScreenController =
                              Get.put(HomeScreenController());
                          homeScreenController.isGettingData.value = true;
                          homeScreenController.homePageData = [].obs;
                          homeScreenController.getHomePageData();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        child: Text(sNo,
                            style: TextStyle(color: cWhiteColor, fontSize: 14)),
                        onPressed: () => Navigator.pop(context)),
                  ]).show();
            }),
        Spacer(),
      ],
    );
  }

  Widget buildImageOnError(BuildContext context) {
    return ClipOval(
      child: Container(
        color: cWhiteColor,
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: Text(
          controller.user.value.name!.characters.first,
          style: TextStyle(
            color: cAppThemeColor,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // Toast
  void showToast(BuildContext context, String msg,
      {int duration = 9, int? gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
