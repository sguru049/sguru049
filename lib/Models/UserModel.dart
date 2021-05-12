import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserModel {
  String? docId;
  String? firebaseUserId;
  String? name;
  String? photoUrl;
  String? email;
  Timestamp? createdAt;
  String? countryCode;
  String? phoneNo;
  RxList<dynamic>? bookmarked;

  UserModel({
    this.docId,
    this.firebaseUserId,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.bookmarked,
    this.countryCode,
    this.phoneNo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        docId: json[kUId],
        firebaseUserId: json[kUFirebaseUserId],
        name: json[kUName],
        email: json[kUEmail],
        countryCode: json[kUCountryCode],
        phoneNo: json[kUPhoneNo],
        photoUrl: json[kUPhotoUrl],
        createdAt: json[kUCreationTS],
        bookmarked: (json[kUBookmarked] as List).obs,
      );

  Map<String, dynamic> toJson() => {
        kUId: docId,
        kUFirebaseUserId: firebaseUserId,
        kUName: name,
        kUEmail: email,
        kUCountryCode: countryCode,
        kUPhoneNo: phoneNo,
        kUPhotoUrl: photoUrl,
        kUCreationTS: createdAt,
        kUBookmarked: bookmarked,
      };
}
