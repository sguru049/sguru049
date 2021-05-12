// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:botox_deals/Assets/DataConstants.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Screens/DetailsScreen/DealTile/dealTile.dart';
import 'package:botox_deals/Screens/HomeScreen/HomeScreenController.dart';
import 'package:botox_deals/Utilities/AppTheme.dart';
import 'package:botox_deals/Utilities/LatLng/LatLng.dart';
import 'package:botox_deals/Utilities/SphericalUtil/SphericalUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'DetailsScreenController.dart';
import 'SocialScreens/facebook.dart';
import 'SocialScreens/twitter.dart';
import 'package:botox_deals/Utilities/Toast/Toast.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/:dataType/details/:user';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => DetailsScreen.create(),
      title: 'details',
      transition: Transition.cupertino);

  static create() => DetailsScreen(
        controller: Get.put(DetailsScreenController()),
        homeController: Get.find(),
      );
  final DetailsScreenController? controller;
  final HomeScreenController? homeController;

  DetailsScreen({Key? key, this.controller, @required this.homeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(
            () =>
                Text((controller!.hasData.value) ? controller!.data.name! : ''),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                String url = window.location.href;
                Clipboard.setData(ClipboardData(text: url));
                showToast(context, sCopied, gravity: Toast.bottom);
              },
            )
          ],
        ),
        body: Container(
          height: max(500, MediaQuery.of(context).size.height),
          child: SingleChildScrollView(child: Obx(() {
            return (controller!.hasData.value)
                ? Column(children: [
                    _buildMain(context),
                    _buildDeals(context),
                  ])
                : Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(child: CircularProgressIndicator()));
          })),
        ));
  }

  Widget _buildMain(BuildContext context) {
    return Container(
        height: max(250, (MediaQuery.of(context).size.height * 0.5)),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(children: [
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  top: 10,
                  child: Image.network(controller!.data.imageUrl!,
                      errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        (controller!.dataType == kBotoxCollectionKey)
                            ? icModelImage
                            : icSalonsPlaceHolder,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width);
                  },
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width),
                ),
                Positioned(right: 20, bottom: 20, child: favButton(context))
              ]),
            ),
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned(
                        left: 10,
                        right: 0,
                        bottom: 10,
                        top: 10,
                        child: _buildModelDetails(context)),
                    Positioned(
                        right: 10,
                        bottom: 10,
                        child: _buildSocialButtonBar(context))
                  ],
                ))
          ],
        ));
  }

  Widget favButton(BuildContext context) {
    return ClipOval(
      child: Container(
        color: cWhiteColor,
        alignment: Alignment.center,
        child: Obx(() {
          return IconButton(
            padding: EdgeInsets.all(2),
            icon: Icon(
              (controller!.userController.user.value.bookmarked != null)
                  ? (controller!.userController.user.value.bookmarked!
                          .contains(controller!.data.docRef))
                      ? Icons.favorite
                      : Icons.favorite_border
                  : Icons.favorite_border,
              color: cPinkColor,
            ),
            onPressed: () {
              if (controller!.userController.user.value.bookmarked != null) {
                controller!.userController
                    .onFavButtonWhenLoggedIn(controller!.data.docRef);
              } else {
                controller!.userController.onFavButtonWhenNotLoggedIn(context,
                    () {
                  homeController!.currentNavigationBarIndex.value = 2;
                  // For Alert Pop
                  Navigator.pop(context);

                  // For Named Route Back
                  Get.back();
                }).show();
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildModelDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: AutoSizeText(controller!.data.name!,
              maxFontSize: kTextFieldFontSize,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
              maxLines: 1),
        ),
        Expanded(
          flex: 2,
          child: AutoSizeText(controller!.data.address!,
              maxFontSize: 14.0,
              style: TextStyle(color: cDarkGrayColor),
              maxLines: 1),
        ),
        Expanded(
          flex: 2,
          child: Obx(() {
            return AutoSizeText(
                (controller!.currentLocationController.hasCurrentLatLong.value)
                    ? "${double.parse((SphericalUtil.computeDistanceBetween(controller!.currentLocationController.currentLatLong, LatLng(controller!.data.latitude as double?, controller!.data.longitude as double?)) * 0.000621372).toStringAsFixed(2))} miles away"
                    : '',
                maxFontSize: 14.0,
                style: TextStyle(color: cDarkGrayColor));
          }),
        ),
        Expanded(
          flex: 2,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(right: 5, top: 2),
                child: Image.asset(icDealsLogo, fit: BoxFit.fitHeight),
              ),
            ),
            Obx(() {
              return (controller!.hasDeals.value)
                  ? Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            (controller!.deals.length == 1)
                                ? "${controller!.deals.length} deal available"
                                : "${controller!.deals.length} deals available",
                            textAlign: TextAlign.start,
                            maxFontSize: 14.0,
                            style: TextStyle(color: cAppThemeColor),
                          )))
                  : AutoSizeText("0 deals available",
                      textAlign: TextAlign.start,
                      maxFontSize: 14.0,
                      style: TextStyle(color: cAppThemeColor));
            }),
          ]),
        )
      ],
    );
  }

  Widget _buildSocialButtonBar(BuildContext context) {
    return ButtonBar(
      buttonPadding: EdgeInsets.all(0),
      children: [
        if (controller!.data.socialLinks![kFb].isNotEmpty)
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.all(4),
            icon: Image.asset(icFacebookLogo),
            onPressed: () {
              Get.to(
                Facebook(controller!.data.socialLinks![kFb][0]),
                fullscreenDialog: true,
                transition: Transition.cupertino,
              );
            },
          ),
        if (controller!.data.socialLinks![kInsta].isNotEmpty)
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.all(4),
            icon: Image.asset(icInstagramLogo),
            onPressed: () {
              window.open(controller!.data.socialLinks![kInsta][0], kInsta);
            },
          ),
        if (controller!.data.socialLinks![kTwitter].isNotEmpty)
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.all(4),
            icon: Image.asset(icTwitterLogo),
            onPressed: () => Get.to(
              Twitter(controller!.data.socialLinks![kTwitter][0]),
              fullscreenDialog: true,
              transition: Transition.cupertino,
            ),
          ),
        if ((controller!.data.socialLinks![kYoutube].isNotEmpty))
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.all(4),
            icon: Image.asset(icYoutubeLogo),
            onPressed: () {
              window.open(controller!.data.socialLinks![kYoutube][0], kYoutube);
            },
          ),
      ],
    );
  }

  _buildDeals(BuildContext context) {
    return Container(
      height: max(250, (MediaQuery.of(context).size.height * 0.5) - 60),
      child: Obx(() {
        return (controller!.hasDeals.value)
            ? ListView.builder(
                itemCount: controller!.deals.length,
                itemBuilder: (context, index) =>
                    DealTileWidget(deal: controller!.deals[index]),
              )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }

  // Toast
  void showToast(BuildContext context, String msg,
      {int duration = 2, int? gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
