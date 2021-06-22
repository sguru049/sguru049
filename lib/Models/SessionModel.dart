import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String? accessToken;
  String? userId;
  Timestamp? createdAt;
  Map<String, dynamic>? deviceDetails;
  int? userType; // 0 for Guest user, 1 for Google user & 2 for Phone No user
  String? messagingToken;

  SessionModel(
      {this.accessToken,
      this.userId,
      this.createdAt,
      this.deviceDetails,
      this.userType,
      this.messagingToken});

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
      messagingToken: json[kSMessagingToken],
      accessToken: json[kSAccessToken],
      userId: json[kSUserId],
      createdAt: json[kSCreationTS],
      deviceDetails: json[kSDeviceDetails],
      userType: json[kSUserType]);

  Map<String, dynamic> toJson() => {
        kSMessagingToken: messagingToken,
        kSAccessToken: accessToken,
        kSUserId: userId,
        kSCreationTS: createdAt,
        kSDeviceDetails: deviceDetails,
        kSUserType: userType,
      };
}
