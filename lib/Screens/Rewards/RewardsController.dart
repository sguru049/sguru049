import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/CouponModel.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum RewardsListType {
  Available,
  Used,
  Expired,
}

extension RewardsListTypeFunctions on RewardsListType {
  static RewardsListType getRewardsListType(String value) {
    switch (value) {
      case sAvailable:
        return RewardsListType.Available;
      case sUsed:
        return RewardsListType.Used;
      case sExpired:
        return RewardsListType.Expired;
      default:
        return RewardsListType.Available;
    }
  }

  static String getStringValue(RewardsListType value) {
    switch (value) {
      case RewardsListType.Available:
        return sAvailable;
      case RewardsListType.Used:
        return sUsed;
      case RewardsListType.Expired:
        return sExpired;
      default:
        return sAvailable;
    }
  }
}

/// This controller is used for all reedem process
class RewardsController extends GetxController {
  //
  List<CouponModel> allCoupons = [];
  List<CouponModel> coupons = [];
  RxBool isGettingCoupons = true.obs;
  Rx<RewardsListType> selectedList = RewardsListType.Available.obs;
  //
  String reedemScreenQrCode = '';
  RxBool isOfferAvailed = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.parameters != null) {
      if (Get.parameters['qrcode'] != null)
        reedemScreenQrCode = Get.parameters['qrcode']!;
    }
    getCoupons();
    super.onReady();
  }

  //

  void getCoupons() {
    final collection =
        FirebaseFirestore.instance.collection(kCouponsCollectionKey);
    isGettingCoupons.value = true;
    // Get coupons from list by session id and if logged in then by user firebase id

    if (CookieManager.isUserLoggedIn()) {
      collection
          .where(kCouponUserId,
              isEqualTo: CookieManager.getCookie(skUserAccessToken))
          .get()
          .then((snapDocs) {
        final data = snapDocs.docs.map((e) => CouponModel.fromJson(e.data()));
        if (data.length != 0) {
          allCoupons = [];
          allCoupons.addAll(data);
          coupons = [];
          List<CouponModel> avialableCoupons = [];
          int status = (selectedList.value == RewardsListType.Available)
              ? 0
              : (selectedList.value == RewardsListType.Used)
                  ? 1
                  : 2;
          for (var c in allCoupons) {
            if (c.status == status) {
              avialableCoupons.add(c);
            }
          }
          coupons.addAll(avialableCoupons);
        }

        /// after completing tasks
        isGettingCoupons.value = false;
      });
    } else {
      collection
          .where(kCouponUserSessionId,
              isEqualTo: CookieManager.getCookie(sKSession))
          .get()
          .then((snapDocs) {
        final data = snapDocs.docs.map((e) => CouponModel.fromJson(e.data()));
        if (data.length != 0) {
          allCoupons = [];
          allCoupons.addAll(data);
          coupons = [];
          List<CouponModel> avialableCoupons = [];
          int status = (selectedList.value == RewardsListType.Available)
              ? 0
              : (selectedList.value == RewardsListType.Used)
                  ? 1
                  : 2;
          for (var c in allCoupons) {
            if (c.status == status) {
              avialableCoupons.add(c);
            }
          }
          coupons.addAll(avialableCoupons);
        }

        /// after completing tasks
        isGettingCoupons.value = false;
      });
    }
  }

  void onRewardListTypeChange(String title) {
    final RewardsListType selection =
        RewardsListTypeFunctions.getRewardsListType(title);
    selectedList.value = selection;
    isGettingCoupons.value = true;
    List<CouponModel> avialableCoupons = [];
    coupons = [];
    int status = (selection == RewardsListType.Available)
        ? 0
        : (selection == RewardsListType.Used)
            ? 1
            : 2;
    for (var c in allCoupons) {
      if (c.status == status) {
        avialableCoupons.add(c);
      }
    }
    coupons.addAll(avialableCoupons);
    300.milliseconds.delay().then((value) {
      isGettingCoupons.value = false;
    });
  }

  void reedemCoupon() {
    FirebaseFirestore.instance
        .collection(kCouponsCollectionKey)
        .where(kCouponQrCode, isEqualTo: '$sCouponPrefix$reedemScreenQrCode')
        .get()
        .then((docsSnap) {
      if (docsSnap.docs.length > 0) {
        docsSnap.docs.first.reference.update({kCouponStatus: 1}).then((value) {
          isOfferAvailed.value = true;
        });
      }
    });
  }
}
