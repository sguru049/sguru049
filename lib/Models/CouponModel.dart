import 'package:beauty_spin/Constants/KeysConstants.dart';

class CouponModel {
  String? title;
  String? desc;

  CouponModel({
    this.title,
    this.desc,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        title: json[kCouponTitle],
        desc: json[kCouponDesc],
      );

  Map<String, dynamic> toJson() => {
        kCouponTitle: title,
        kCouponDesc: desc,
      };
}

// const kCouponTitle = 'title';
// const kCouponDesc = 'desc';
// const kCouponQrCode = 'qrCode';
// const kCouponUserId = 'userId';
// const kCouponUserSessionId = 'userSessionId';
// const kCouponStatus = 'Status';
// const kCouponCreatedAt = 'createdAt';
// const kCouponValidTill = 'validTill';
// const kCouponClincsList = 'Clinics';
// const kCouponId = 'couponId';