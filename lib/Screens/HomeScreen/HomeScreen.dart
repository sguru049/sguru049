import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Assets/DataConstants.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
// import 'package:beauty_spin/Models/NotificationsModel.dart';
import 'package:beauty_spin/Screens/FortuneWheel/FortuneWheelScreen.dart';
import 'package:beauty_spin/Screens/HomeScreen/CitySelector/CitySelector.dart';
import 'package:beauty_spin/Screens/NotificationsScreen/Notifications.dart';
import 'package:beauty_spin/Screens/OfflineScreen/OfflineScreen.dart';
import 'package:beauty_spin/Screens/SearchScreen/SearchScreen.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfile.dart';
import 'package:beauty_spin/Services/HttpServices/HttpServices.dart';
import 'package:beauty_spin/Utilities/AppTheme.dart';
import 'package:beauty_spin/Utilities/CommonFunctions.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'HomeScreenController.dart';
import 'HomeScreenViews/HomeScreenMap.dart';
import 'HomeScreenViews/HomeScreenList.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => HomeScreen.create(),
      title: 'home',
      transition: Transition.cupertino);

  static create() => HomeScreen(controller: Get.put(HomeScreenController()));

  final HomeScreenController controller;
  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: sHomeButtonLabel),
            BottomNavigationBarItem(
                icon: Image.asset(icSpin2Win, width: 24, height: 24),
                label: sSpin2WinLabel),
            BottomNavigationBarItem(
                icon: Stack(children: [
                  Icon(Icons.notifications),
                  Obx(() {
                    final hasNotification = (controller
                            .notificationsScreenController
                            .hasNotifications
                            .value &&
                        controller.notificationsScreenController.notifications
                                .length !=
                            0);

                    int unReadNotificationsCount = 0;

                    for (var n in controller
                        .notificationsScreenController.notifications) {
                      if (!n.isRead!.value) {
                        unReadNotificationsCount++;
                      }
                    }

                    return (hasNotification && unReadNotificationsCount != 0)
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: cDarkGrayColor),
                                  color: cWhiteColor,
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              width: 14,
                              height: 14,
                              child: AutoSizeText('$unReadNotificationsCount',
                                  minFontSize: 6,
                                  style: TextStyle(
                                      color: cRedColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700)),
                            ))
                        : SizedBox.shrink();
                  })
                ]),
                label: sNotificationsLabel),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: sProfileButtonLabel)
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: cAppThemeColor,
          selectedItemColor: cWhiteColor,
          unselectedItemColor: cDarkGrayColor,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: controller.currentNavigationBarIndex.value,

          // /// When Profile has multiple Login Type
          // onTap: (value) => controller.currentNavigationBarIndex.value = value,

          /// When Profile has only one Login Type
          onTap: (value) {
            controller.currentNavigationBarIndex.value = value;
            if (value == 3) {
              controller.userController.phoneNumberFocusNode.requestFocus();
            } else {
              controller.userController.emptyLoginScreenControllers();
            }
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              (controller.currentNavigationBarIndex.value == 0)
                  ? sHomePageTitle
                  : (controller.currentNavigationBarIndex.value == 1)
                      ? sSpin2WinTitle
                      : (controller.currentNavigationBarIndex.value == 2)
                          ? sNotificationsTitle
                          : sMyProfileTitle,
              style: GoogleFonts.comfortaa()),
          actions: [
            (controller.currentNavigationBarIndex.value == 0)
                ? AnimatedIconButton(icons: [
                    AnimatedIconItem(
                        icon: Icon(Icons.pin_drop, color: cWhiteColor),
                        onPressed: () => controller.changeHomePageType()),
                    AnimatedIconItem(
                        icon: Icon(Icons.list, color: cWhiteColor),
                        onPressed: () => controller.changeHomePageType())
                  ])
                : SizedBox.shrink()
          ],
        ),
        // ///.... To show alert for new Updated app and clear cache
        // body: Obx(() {
        //     if (!controller.isUsingUpdatedVersion.value) {
        //       Alert(
        //           onWillPopActive: true,
        //           style: AlertStyle(
        //               isCloseButton: false,
        //               titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor),
        //               descStyle: TextStyle(fontSize: 14, color: cDarkGrayColor)),
        //           context: context,
        //           title: 'New Version Installed',
        //           desc: 'Please Restart',
        //           buttons: []).show();
        //     }
        body: ConnectivityBuilder(builder: (context, isConnected, status) {
          return (!isConnected!)
              ? OfflineScreen()
              : Obx(() {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: (controller.currentNavigationBarIndex.value == 0)
                            ? _buildMain(context)
                            : (controller.currentNavigationBarIndex.value == 1)
                                ? FortuneWheelScreen()
                                : (controller.currentNavigationBarIndex.value ==
                                        2)
                                    ? NotificationsScreen()
                                    : UserProfileScreen(),
                      ),
                      _build100thUserNotification(context),
                      // _buildBottomSlideNotification(
                      //   context,
                      //   'You’re ${controller.userController.ordinal(controller.userController.currentUserCount)} visitor',
                      // )
                    ],
                  );
                });
        }),
      );
    });
  }

  Widget _build100thUserNotification(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.0),
      child: AnimatedContainer(
          duration: 400.milliseconds,
          width: controller.userController.showWinnerNotificationInApp.value
              ? MediaQuery.of(context).size.width - 10
              : 0,
          height: controller.userController.showWinnerNotificationInApp.value
              ? MediaQuery.of(context).size.height - 120
              : 0,
          decoration: BoxDecoration(
            color: cWhiteColor,
            boxShadow:
                (controller.userController.showWinnerNotificationInApp.value)
                    ? [BoxShadow(spreadRadius: 2.0, blurRadius: 2.0)]
                    : [],
          ),
          child: controller.userController.startAnimation.value
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Lottie.asset(jcCongratsAnimation, repeat: false),
                    Lottie.asset(jcBackgroundSplash),
                    Center(
                      child: Text(
                        'You are the ${controller.userController.ordinal(controller.userController.currentUserCount)} visitor',
                        style: GoogleFonts.caveat(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color.fromRGBO(114, 20, 160, 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      bottom: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.yellow[600],
                                  ),
                                  child: Text(
                                    sClaim,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  )),
                              onTap: () {
                                onCliamTapped(context);
                              },
                            ),
                          ]),
                    ),
                  ],
                )
              : Text('')),
    );
  }

  // Widget _buildBottomSlideNotification(BuildContext context,
  //     [String title = '', String body = sKeepVisitingUs]) {
  //   return GestureDetector(
  //     child: AnimatedAlign(
  //       duration: 1.seconds,
  //       alignment:
  //           controller.userController.showUserCountNotificationInApp.value
  //               ? Alignment(0.0, 0.98)
  //               : Alignment(0.0, 1.4),
  //       child: Stack(
  //         children: [
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.95,
  //             decoration: BoxDecoration(
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey[400]!,
  //                   spreadRadius: 1.5,
  //                   blurRadius: 0.75,
  //                 )
  //               ],
  //             ),
  //             child: NotificationItemTile(
  //                 notification: NotificationModel(
  //                   title: title,
  //                   body: body,
  //                   isRead: false.obs,
  //                   creationTS: Timestamp.now(),
  //                 ),
  //                 isRead: false.obs),
  //           ),
  //           Positioned.fill(
  //             child: Container(
  //               width: MediaQuery.of(context).size.width * 0.95,
  //               height: 50,
  //               color: Colors.transparent,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       controller.userController.showUserCountNotificationInApp.value = false;
  //     },
  //   );
  // }

  Widget _buildMain(BuildContext context) {
    return Column(children: [
      // Data Type Selector Bar
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Obx(() {
            return (controller.userController.user.value.bookmarked != null)
                ? GestureDetector(
                    child: TopBarButton(
                        text: sTbFavTitle,
                        isSelected: (controller.currentDataViewType.value ==
                                TopBarButtonType.fav)
                            .obs),
                    onTap: () {
                      controller.currentDataViewType.value =
                          TopBarButtonType.fav;
                      if (controller.previousDataViewType.value !=
                          controller.currentDataViewType.value) {
                        controller.getFavData();
                      }
                    })
                : SizedBox.shrink();
          }),
          GestureDetector(
            child: TopBarButton(
                text: sSbBotoxTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.botox)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.botox);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbWaxTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.wax)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.wax);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbTanTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.tan)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.tan);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbNailsTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.nails)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.nails);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbLashesTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.lashes)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.lashes);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbBrowTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.brow)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.brow);
            },
          ),
          GestureDetector(
            child: TopBarButton(
                text: sSbBlowoutTitle,
                isSelected: (controller.currentDataViewType.value ==
                        TopBarButtonType.blowout)
                    .obs),
            onTap: () {
              controller.changeTopBarViewType(TopBarButtonType.blowout);
            },
          ),
        ]),
      ),
      // City Selector Bar
      Row(children: [
        GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 30,
              padding: EdgeInsets.only(left: 20),
              child: Row(children: [
                Icon(Icons.search, size: 16),
                Container(width: 5, height: 20),
                AutoSizeText(sSearch,
                    style: kBlueTextTheme.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline)),
              ]),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen(
                    currentDataType: controller.currentDataViewType.value);
              }));
            }),
        Spacer(),
        if (controller.currentDataViewType.value != TopBarButtonType.fav)
          Container(
            alignment: Alignment.center,
            height: 30,
            padding: EdgeInsets.only(left: 20),
            child: AutoSizeText(
                '${controller.homePageData.length} ${TopBarBTFunctions.getTopBarTitleText(controller.currentDataViewType.value)} in '),
          ),
        if (controller.currentDataViewType.value != TopBarButtonType.fav)
          Container(
            alignment: Alignment.center,
            height: 30,
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: AutoSizeText(controller.selectedCityState.value,
                  style: kBlueTextTheme.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CitySelector()));
              },
            ),
          )
      ]),

      // Main View
      (controller.isGettingData.value)
          ? Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
              child: AnimatedSwitcher(
              duration: Duration(milliseconds: 333),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeInOut,
              child: (controller.homePageType.value == HomePageType.list)
                  ? HomeScreenList()
                  : HomeScreenMap(),
            ))
    ]);
  }

  void onCliamTapped(BuildContext context) {
    controller.userController.showWinnerNotificationInApp.value = false;
    controller.userController.startAnimation.value = false;
    controller.addInWinnerList();
    if (controller.userController.hasUser.value) {
      HttpServices().sendSms(
        to: controller.userController.user.value.phoneNo,
        message: sClaimButtonSmsMessage,
      );
    } else {
      Alert(
        context: context,
        title: sLoginToAvailOffer,
        style: AlertStyle(
            isCloseButton: false,
            titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor),
            descStyle: TextStyle(fontSize: 14, color: cAppThemeColor)),
        buttons: [
          DialogButton(
              child:
                  Text(sCancel, style: kWhiteTextTheme.copyWith(fontSize: 14)),
              onPressed: () {
                Navigator.pop(context);
                Alert(
                  context: context,
                  title: sYouSure,
                  desc: sLooseThisOffer,
                  style: AlertStyle(
                      isCloseButton: false,
                      titleStyle:
                          TextStyle(fontSize: 16, color: cAppThemeColor),
                      descStyle:
                          TextStyle(fontSize: 14, color: cAppThemeColor)),
                  buttons: [
                    DialogButton(
                        child: Text(sCancel,
                            style: kWhiteTextTheme.copyWith(fontSize: 14)),
                        onPressed: () {
                          controller.currentNavigationBarIndex.value = 2;
                          Navigator.pop(context);
                        }),
                    DialogButton(
                      child: Text(sOk,
                          style: kWhiteTextTheme.copyWith(fontSize: 14)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ).show();
              }),
          DialogButton(
              child: Text(sOk, style: kWhiteTextTheme.copyWith(fontSize: 14)),
              onPressed: () {
                controller.currentNavigationBarIndex.value = 2;
                Navigator.pop(context);
              }),
        ],
      ).show();
    }
  }
}

class TopBarButton extends StatelessWidget {
  const TopBarButton({
    Key? key,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  final String text;
  final RxBool isSelected;

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = 36;
    return Obx(() {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.center,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonHeight / 2),
          border: Border.all(width: 2, color: cAppThemeColor),
          color: (isSelected.value) ? cAppThemeColor : cWhiteColor,
        ),
        child: AutoSizeText(
          text,
          maxLines: 1,
          style: (TextStyle(
              color: (isSelected.value) ? cWhiteColor : cAppThemeColor)),
        ),
      );
    });
  }
}
