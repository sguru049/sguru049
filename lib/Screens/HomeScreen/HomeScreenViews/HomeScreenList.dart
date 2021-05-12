import 'package:auto_size_text/auto_size_text.dart';
import 'package:botox_deals/Constants/ColorConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Screens/HomeScreen/HomeScreenItemTile/HomScreenItemTile.dart';
import 'package:botox_deals/Utilities/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../HomeScreenController.dart';

class HomeScreenList extends StatelessWidget {
  final HomeScreenController? controller;
  const HomeScreenList({Key? key, @required this.controller}) : super(key: key);

  static create() => HomeScreenList(controller: Get.find());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (controller!.homePageData.isEmpty)
          ? placeHolderWidget(context)
          : listViewWidget(context);
    });
  }

  Widget placeHolderWidget(BuildContext context) {
    final currentDataType = controller!.currentDataViewType.value;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Heading
          AutoSizeText(
              (currentDataType == TopBarButtonType.fav)
                  ? sNoFavYet
                  : 'No ${(currentDataType == TopBarButtonType.botox) ? 'Clinics' : 'Salons'} found here ',
              style: TextStyle(color: Colors.black26, fontSize: 22)),
          SizedBox(height: 20),
          // Description
          (currentDataType == TopBarButtonType.fav)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      AutoSizeText(sTap, style: kPlaceHolderGrayTextStyle),
                      Icon(Icons.favorite_border, color: cPinkColor),
                      AutoSizeText(sToAddFav, style: kPlaceHolderGrayTextStyle)
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      sUpdatingRegularly,
                      style: kPlaceHolderGrayTextStyle,
                    ),
                    AutoSizeText(
                      sFeelFreeToCheck,
                      style: kPlaceHolderGrayTextStyle,
                    )
                  ],
                )
        ],
      ),
    );
  }

  Widget listViewWidget(BuildContext context) {
    final currentDataType = controller!.currentDataViewType.value;
    return Scrollbar(
      child: RefreshIndicator(
        child: ListView.builder(
            itemCount: controller!.homePageData.length,
            itemBuilder: (context, index) {
              return Container(
                color: cBackGroundColor,
                child: (index == 0)
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Obx(() {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller!.promotionQueueItem.value.name !=
                                    null)
                                  Stack(
                                    children: [
                                      HomScreenItemTile.create(
                                        controller!.promotionQueueItem.value,
                                        currentDataType,
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                            color: cAppThemeColor,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 2),
                                            child: AutoSizeText(sPromoted,
                                                style: kWhiteTextTheme)),
                                      )
                                    ],
                                  ),
                                HomScreenItemTile.create(
                                  controller!.homePageData[index],
                                  currentDataType,
                                ),
                              ]);
                        }),
                      )
                    : HomScreenItemTile.create(
                        controller!.homePageData[index],
                        currentDataType,
                      ),
              );
            }),
        onRefresh: () {
          if (controller!.currentDataViewType.value == TopBarButtonType.fav) {
            return Future.delayed(Duration(milliseconds: 300)).then((value) {
              controller!.getFavData();
            });
          } else {
            return controller!.updatePromotionQueueItem();
          }
        },
      ),
    );
  }
}
