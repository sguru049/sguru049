import 'dart:math';
import 'package:botox_deals/Assets/DataConstants.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Models/AppDataModel.dart';
import 'package:botox_deals/Screens/UserProfile/UserProfileController.dart';
import 'package:botox_deals/Services/CurrentLocationController.dart';
import 'package:botox_deals/Utilities/AppTheme.dart';
import 'package:botox_deals/Utilities/LatLng/LatLng.dart';
import 'package:botox_deals/Utilities/SphericalUtil/SphericalUtil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Models/DealsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../HomeScreenController.dart';
import 'package:botox_deals/Utilities/Toast/Toast.dart';

// ignore: must_be_immutable
class HomScreenItemTile extends StatelessWidget {
  HomScreenItemTile(
      {Key? key, required this.model, required this.currentDataType})
      : super(key: key);

  static create(AppDataModel model, TopBarButtonType type) =>
      HomScreenItemTile(model: model, currentDataType: type);

  RxInt deals = 0.obs;
  final AppDataModel? model;
  final TopBarButtonType currentDataType;
  final CurrentLocationController currentLocationController = Get.find();
  final UserProfileScreenController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.toNamed(
              '/${model!.docRef.toString().split('/').first.split('(').last}/details/${model!.docId}');
        },
        child: Container(
          height: max(90, (MediaQuery.of(context).size.height / 7)),
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cWhiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            _buildImage(context),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: _buildModelDetails())),
                  Positioned(
                      right: 0, bottom: 0, child: _buildFavButton(context))
                ],
              ),
            )
          ]),
        ));
  }

  Widget _buildImage(BuildContext context) {
    return Image.network(
      model!.imageUrl!,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          (model!.docRef.toString().split('/').first.split('(').last ==
                  kBotoxCollectionKey)
              ? icModelImageThumb
              : icSalonsPlaceHolderThumb,
          width: max(70, (MediaQuery.of(context).size.height / 7) - 20),
          fit: BoxFit.fitWidth,
        );
      },
      width: max(70, (MediaQuery.of(context).size.height / 7) - 20),
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildFavButton(BuildContext context) {
    return Obx(() {
      return IconButton(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(2),
          icon: Icon(
            (userController.user.value.bookmarked != null)
                ?
                // ignore: invalid_use_of_protected_member
                (userController.user.value.bookmarked!.value
                        .contains(model!.docRef))
                    ? Icons.favorite
                    : Icons.favorite_border
                : Icons.favorite_border,
            color: cPinkColor,
          ),
          onPressed: () {
            if (userController.user.value.bookmarked != null)
              userController.onFavButtonWhenLoggedIn(model!.docRef);
            else
              userController.onFavButtonWhenNotLoggedIn(
                context,
                () {
                  final HomeScreenController homeScreenController = Get.find();
                  homeScreenController.currentNavigationBarIndex.value = 2;
                  Navigator.pop(context);
                },
              ).show();
          });
    });
  }

  Widget _buildModelDetails() {
    getDeals(model!.docRef);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: AutoSizeText(model!.name!,
              maxFontSize: kBoldFontSize,
              style: TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1),
        ),
        Expanded(
          flex: 2,
          child: AutoSizeText('${model!.address}',
              maxFontSize: 14.0,
              style: TextStyle(color: cDarkGrayColor),
              maxLines: 1),
        ),
        Expanded(
          flex: 2,
          child: Obx(() {
            return AutoSizeText(
                (currentLocationController.hasCurrentLatLong.value)
                    ? "${double.parse((SphericalUtil.computeDistanceBetween(currentLocationController.currentLatLong, LatLng(model!.latitude as double?, model!.longitude as double?)) * 0.000621372).toStringAsFixed(2))} miles away"
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
            Expanded(
              child: Obx(() {
                return Container(
                    alignment: Alignment.topLeft,
                    child: AutoSizeText(
                      (deals.value == 1)
                          ? "${deals.value} deal available"
                          : "${deals.value} deals available",
                      textAlign: TextAlign.start,
                      maxFontSize: 14.0,
                      style: TextStyle(color: cAppThemeColor),
                    ));
              }),
            ),
          ]),
        )
      ],
    );
  }

  void getDeals(DocumentReference? reference) {
    FirebaseFirestore.instance
        .collection(
            '${TopBarBTFunctions.getCollectionStringValue(currentDataType)}$kDealsSuffixKey')
        .where(kDId, isEqualTo: reference)
        .get()
        .then((dealsSnap) {
      final newDeals =
          dealsSnap.docs.map((e) => DealModel.fromJson(e.id, e.data()));
      deals.value = newDeals.length;
    });
  }

  // Toast
  void showToast(BuildContext context, String msg,
      {int duration = 2, int? gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
