import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/SessionModel.dart';
import 'package:beauty_spin/Models/UserModel.dart';
import 'package:beauty_spin/Models/WinnerDBModel.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:beauty_spin/Services/HttpServices/HttpServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

enum UserType { Google, PhoneNo }

class UserProfileScreenController extends GetxController {
  // Sign in instances
  GoogleSignIn googleSignIn = GoogleSignIn();

  String? phoneSignInNo = '';
  String firebaseUserId = '';

  //
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  //

  RxBool isUserSignedIn = false.obs;
  RxBool hasUser = false.obs;
  RxBool hasUserName = false.obs;
  Rx<UserModel> user = UserModel().obs;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  // Show Notification In App
  RxBool showWinnerNotificationInApp = false.obs;
  RxBool startAnimation = false.obs;
  // RxBool showUserCountNotificationInApp = false.obs;
  int currentUserCount = 0;

  RxBool showToast = false.obs;

  // Temp Variables need to put back on login Controller
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode phoneNumberFocusNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  RxBool isNoEntered = false.obs;
  //

  @override
  void onInit() {
    isUserSignedIn.value = CookieManager.isUserLoggedIn();
    getDeviceDetails();
    if (isUserSignedIn.value)
      getUser(CookieManager.getCookie(skUserAccessToken));
    super.onInit();
  }

  // Temp
  void emptyLoginScreenControllers() {
    phoneNumberController.text = sCountryCode;
    otpController.text = '';
    isNoEntered.value = false;
  }

  void sendNotification() {
    FirebaseFirestore.instance
        .collection(kVisitorsCounterColloectionKey)
        .doc(kVisitorsCounterDocKey)
        .get()
        .then((value) {
      final doc = value.data()!;
      final int notifyOn = doc[kNotifyOnCount];
      final List<dynamic> array = doc[kVisitors];
      currentUserCount = array.length;
      if (array.length % notifyOn == 0) {
        // // Get Required Session
        FirebaseFirestore.instance
            .collection(kUserSessionCollectionKey)
            .where(kSAccessToken, isEqualTo: CookieManager.getCookie(sKSession))
            .get()
            .then((value) {
          final docs = value.docs.map((e) => SessionModel.fromJson(e.data()));
          if (docs.isNotEmpty) {
            final SessionModel requierdSession = docs.first;
            // // Show 100th User Notifications in app
            showWinnerNotificationInApp.value = true;
            Future.delayed(800.milliseconds).then((value) {
              startAnimation.value = true;
            });
            // //  Add in Notifications List
            FirebaseFirestore.instance
                .collection(kNotificationsCollectionKey)
                .add({
              kNSessionAccessToken: requierdSession.accessToken,
              kNUserId: requierdSession.userId,
              kNCreationTS: Timestamp.now(),
              kNTitle: sNTitleValue,
              kNBody: 'You are the ${ordinal(currentUserCount)} visitor',
              kNIsRead: false,
              kNType: 0,
            }).then((value) {
              if (requierdSession.userId == null) {
                CookieManager.deleteCookie(sNDocId);
                CookieManager.addToCookie(sNDocId, value.id);
              }
            });
            // Send Notification
            HttpServices().sendNotification(
              messagingToken: requierdSession.messagingToken,
              notificationTitle: sNTitleValue,
              notificationBody:
                  'You are the ${ordinal(currentUserCount)} visitor',
            );
          }
        });
      }
      // else {
      // // Show Notifications in app
      // showUserCountNotificationInApp.value = true;
      // Future.delayed(10.seconds).then((value) {
      //   showUserCountNotificationInApp.value = false;
      // });
      // }
    });
  }

  Alert onFavButtonWhenNotLoggedIn(BuildContext context, Function onLogin) {
    return Alert(
        onWillPopActive: true,
        style: AlertStyle(
            isCloseButton: false,
            titleStyle: TextStyle(fontSize: 16, color: cAppThemeColor)),
        context: context,
        title: sFavButtonAlertTitle,
        buttons: [
          DialogButton(
              child:
                  Text(sCancelButtonText, style: TextStyle(color: cWhiteColor)),
              onPressed: () => Navigator.pop(context)),
          DialogButton(
              child: Text(sLogin, style: TextStyle(color: cWhiteColor)),
              onPressed: () => onLogin())
        ]);
  }

  void onFavButtonWhenLoggedIn(DocumentReference? documentReference) {
    // ignore: invalid_use_of_protected_member
    if (user.value.bookmarked!.value.contains(documentReference)) {
      List<dynamic> newList = [];
      // ignore: invalid_use_of_protected_member
      for (var doc in user.value.bookmarked!.value)
        if (doc != documentReference) newList.add(doc);
      // ignore: deprecated_member_use
      user.value.bookmarked!.value = newList;
      FirebaseFirestore.instance
          .collection(kUserCollectionKey)
          .doc(user.value.docId)
          .update({kUBookmarked: newList});
    } else {
      final List<dynamic> newList =
          // ignore: invalid_use_of_protected_member
          user.value.bookmarked!.value + [documentReference];
      // ignore: deprecated_member_use
      user.value.bookmarked!.value = newList;
      FirebaseFirestore.instance
          .collection(kUserCollectionKey)
          .doc(user.value.docId)
          .update({kUBookmarked: newList});
    }
  }

  void enterNameScreenDoneButtonTapped() {
    if (nameController.text.length >= 4) {
      FirebaseFirestore.instance
          .collection(kUserCollectionKey)
          .doc(user.value.docId)
          .update({kUName: nameController.text}).then((value) {
        getUser(user.value.firebaseUserId);
      });
    }
  }

  void getUser(String? id) {
    FirebaseFirestore.instance
        .collection(kUserCollectionKey)
        .where(kUFirebaseUserId, isEqualTo: id)
        .get()
        .then((snap) {
      final users = snap.docs.map((e) => UserModel.fromJson(e.data()));
      if (users.isNotEmpty) {
        user.value = users.first;
        hasUser.value = true;
        isUserSignedIn.value = true;
        if (user.value.name == null) {
          nameFocusNode.requestFocus();
          hasUserName.value = false;
        }
        if (user.value.name!.length >= 3) {
          hasUserName.value = true;
          checkIsWinnerListHasUser();
        }
      }
    });
  }

  void checkIsWinnerListHasUser() {
    FirebaseFirestore.instance
        .collection(kWinnersCollectionKey)
        .where(kWSessionAccessToken,
            isEqualTo: CookieManager.getCookie(sKSession))
        .get()
        .then((value) {
      final docs =
          value.docs.map((e) => WinnerModel.fromJson(e.reference, e.data()));
      for (var doc in docs) {
        if (!doc.isMailSent!) {
          doc.docRef!.update({
            kWName: user.value.name,
            kWIsMailSent: true,
            kWEmail: user.value.email ?? 'NA',
            kWPhone: user.value.phoneNo ?? 'NA',
          }).then((value) {
            print('sms sent');
            HttpServices().sendSms(
              to: user.value.phoneNo,
              message: sClaimButtonSmsMessage,
            );
          });
        }
      }
    });
  }

  createUser(UserType type) {
    FirebaseFirestore.instance
        .collection(kUserCollectionKey)
        .add({}).then((value) {
      switch (type) {
        case UserType.Google:
          updateSessionToGoogle(value.id);
          value.update({
            kUId: value.id,
            kUFirebaseUserId: googleSignIn.currentUser!.id,
            kUName: googleSignIn.currentUser!.displayName,
            kUPhotoUrl: googleSignIn.currentUser!.photoUrl,
            kUEmail: googleSignIn.currentUser!.email,
            kUCreationTS: Timestamp.now(),
            kUBookmarked: [],
            kUPhoneNo: null,
            kUCountryCode: null
          }).then((value) {
            getUser(CookieManager.getCookie(skUserAccessToken));
            isUserSignedIn.value = true;
            showToast.value = true;
          });
          break;
        case UserType.PhoneNo:
          updateSessionToPhone(value.id);
          value.update({
            kUId: value.id,
            kUFirebaseUserId: firebaseUserId,
            kUPhotoUrl: null,
            kUEmail: null,
            kUCreationTS: Timestamp.now(),
            kUBookmarked: [],
            kUName: null,
            kUPhoneNo: phoneSignInNo,
            kUCountryCode: sCountryCode,
          }).then((value) {
            getUser(CookieManager.getCookie(skUserAccessToken));
            isUserSignedIn.value = true;
            showToast.value = true;
            Get.back();
          });
          break;
        default:
          break;
      }
    });
  }

  void createSession() {
    final token = UniqueKey();
    CookieManager.addToCookie(sKSession, token.toString());
    FirebaseFirestore.instance.collection(kUserSessionCollectionKey).doc().set({
      kSAccessToken: token.toString(),
      kSMessagingToken: null,
      kSUserId: null,
      kSUserType: 0,
      kSCreationTS: Timestamp.now(),
      kSDeviceDetails: deviceData,
    });
    addVisitorCounter();
  }

  // Update Session To Google
  updateSessionToGoogle(String? userId) {
    FirebaseFirestore.instance
        .collection(kUserSessionCollectionKey)
        .where(kSAccessToken, isEqualTo: CookieManager.getCookie(sKSession))
        .get()
        .then((value) {
      final docs = value.docs.map((e) => e.reference);
      if (docs.isNotEmpty) docs.first.update({kSUserId: userId, kSUserType: 1});
    });
    final notificationId = CookieManager.getCookie(sNDocId);
    if (notificationId.length > 1) {
      CookieManager.deleteCookie(sNDocId);
      FirebaseFirestore.instance
          .collection(kNotificationsCollectionKey)
          .doc(notificationId)
          .update({kNUserId: userId});
    }
  }

  // Update Session To Phone
  updateSessionToPhone(String? userId) {
    FirebaseFirestore.instance
        .collection(kUserSessionCollectionKey)
        .where(kSAccessToken, isEqualTo: CookieManager.getCookie(sKSession))
        .get()
        .then((value) {
      final docs = value.docs.map((e) => e.reference);
      if (docs.isNotEmpty) docs.first.update({kSUserId: userId, kSUserType: 2});
    }).then(((value) => Get.back()));
    final notificationId = CookieManager.getCookie(sNDocId);
    if (notificationId.length > 1) {
      CookieManager.deleteCookie(sNDocId);
      FirebaseFirestore.instance
          .collection(kNotificationsCollectionKey)
          .doc(notificationId)
          .update({kNUserId: userId});
    }
  }

  void revertToGuestSession() {
    CookieManager.deleteCookie(skUserAccessToken);
    FirebaseFirestore.instance
        .collection(kUserSessionCollectionKey)
        .where(kSAccessToken, isEqualTo: CookieManager.getCookie(sKSession))
        .get()
        .then((value) {
      final docs = value.docs.map((e) => e.reference);
      if (docs.isNotEmpty) docs.first.update({kSUserId: null, kSUserType: 0});
    });
    hasUser.value = false;
    user.value = UserModel();
    isUserSignedIn.value = false;
  }

  void addVisitorCounter() {
    String sessionAccessToken = CookieManager.getCookie(sKSession);
    final visitorsDoc = FirebaseFirestore.instance
        .collection(kVisitorsCounterColloectionKey)
        .doc(kVisitorsCounterDocKey);
    visitorsDoc.get().then((counter) {
      final visitors = counter.data()![kVisitors];
      List<dynamic> myVisitors = [];
      myVisitors.addAll(visitors);
      if (myVisitors.length == 0 || myVisitors.last != sessionAccessToken) {
        myVisitors.add(sessionAccessToken);
        visitorsDoc.update({kVisitors: myVisitors}).then(
            (value) => sendNotification());
      }
    });
  }

  void addMessagingToken() async {
    final messagingInstance = FirebaseMessaging.instance;
    await messagingInstance.requestPermission();
    final token = await messagingInstance.getToken();
    FirebaseFirestore.instance
        .collection(kUserSessionCollectionKey)
        .where(kSAccessToken, isEqualTo: CookieManager.getCookie(sKSession))
        .get()
        .then((value) {
      final docs = value.docs.map((e) => e.reference);
      if (docs.isNotEmpty) docs.first.update({kSMessagingToken: token});
    });
  }

  void getDeviceDetails() async {
    var dData = <String, dynamic>{};
    try {
      dData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      deviceData = dData;
      if (CookieManager.getCookie(sKSession).isEmpty) {
        createSession();
        addMessagingToken();
      } else {
        addVisitorCounter();
      }
    } on PlatformException {
      dData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
      print(dData);
    }
  }

  String ordinal(int no) {
    String number = no.toString();
    String returnValue = '${number}th';
    switch (number.split('').last) {
      case '1':
        if (no > 10 && number.split('')[number.length - 2] == '1') {
          return returnValue;
        } else {
          returnValue = '${number}st';
          return returnValue;
        }

      case '2':
        if (no > 10 && number.split('')[number.length - 2] == '1') {
          return returnValue;
        } else {
          returnValue = '${number}nd';
          return returnValue;
        }

      case '3':
        if (no > 10 && number.split('')[number.length - 2] == '1') {
          return returnValue;
        } else {
          returnValue = '${number}rd';
          return returnValue;
        }

      default:
        return returnValue;
    }
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }
}
