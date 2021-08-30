import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? couponId;
  String? userId;
  String? sessionId;
  String? title;
  String? desc;
  String? qrCode;
  int status;
  Timestamp? createdAt;
  Timestamp? validTill;
  List<dynamic>? clincIdsList;

  CouponModel({
    this.couponId,
    this.userId,
    this.sessionId,
    this.title,
    this.desc,
    this.qrCode,
    required this.status,
    this.createdAt,
    this.validTill,
    this.clincIdsList,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        couponId: json[kCouponId],
        userId: json[kCouponUserId] ?? '',
        sessionId: json[kCouponUserSessionId],
        title: json[kCouponTitle],
        desc: json[kCouponDesc],
        qrCode: json[kCouponQrCode],
        status: json[kCouponStatus],
        createdAt: json[kCouponCreatedAt],
        validTill: json[kCouponValidTill],
        clincIdsList: json[kCouponClincsList],
      );

  Map<String, dynamic> toJson() => {
        kCouponId: couponId,
        kCouponUserId: userId,
        kCouponUserSessionId: sessionId,
        kCouponTitle: title,
        kCouponDesc: desc,
        kCouponQrCode: qrCode,
        kCouponStatus: status,
        kCouponCreatedAt: createdAt,
        kCouponValidTill: validTill,
        kCouponClincsList: clincIdsList,
      };

  /// status:  0 for available, 1 for used and 2 for expired
  static saveCouponInFirebase({
    required String userId,
    required String sessionId,
    required String title,
    required String desc,
    required int status,
    DateTime? validTill,
    List<String>? clincIdsList,
  }) {
    FirebaseFirestore.instance
        .collection(kCouponsCollectionKey)
        .add({}).then((value) {
      FirebaseFirestore.instance
          .collection(kCouponsCollectionKey)
          .doc(value.id)
          .update({
        kCouponId: value.id,
        kCouponUserId: userId,
        kCouponUserSessionId: sessionId,
        kCouponTitle: title,
        kCouponDesc: desc,
        kCouponQrCode: '$sCouponPrefix${value.id}',
        kCouponStatus: status,
        kCouponCreatedAt: new Timestamp.now(),
        kCouponValidTill: validTill,
        kCouponClincsList: clincIdsList ?? [],
      });
    });
  }
}
