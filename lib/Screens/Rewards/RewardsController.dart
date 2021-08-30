import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/CouponModel.dart';
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
}

/// This controller is used for all reedem process
class RewardsController extends GetxController {
  //
  RxList<CouponModel> coupons = RxList<CouponModel>();
  RxBool isGettingCoupons = true.obs;
  Rx<RewardsListType> selectedList = RewardsListType.Available.obs;
  //

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getCoupons();
    super.onReady();
  }

  //

  void getCoupons() {
    isGettingCoupons.value = true;
    // TODO : Get coupons from list by guest session and if logged in then by user session

    /// after completing tasks
    isGettingCoupons.value = false;
  }

  void onRewardListTypeChange(String title) {
    final RewardsListType selection =
        RewardsListTypeFunctions.getRewardsListType(title);
    selectedList.value = selection;
    // TODO : On change rewards list type
  }

  void reedemCoupon(String qrcode) {
    // TODO : Reedem coupon from scannig screen
  }

  //
}
