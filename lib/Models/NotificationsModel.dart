import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class NotificationModel {
  DocumentReference? docRef;
  String? sessionAccessToken;
  String? userId;
  String? title;
  String? body;
  Timestamp? creationTS;
  RxBool? isRead;
  int? type;

  NotificationModel({
    this.docRef,
    this.title,
    this.body,
    this.sessionAccessToken,
    this.userId,
    this.creationTS,
    this.isRead,
    this.type,
  });

  factory NotificationModel.fromJson(
          DocumentReference documentReference, Map<String, dynamic> json) =>
      NotificationModel(
        docRef: documentReference,
        title: json[kNTitle],
        body: json[kNBody],
        sessionAccessToken: json[kNSessionAccessToken],
        userId: json[kNUserId],
        creationTS: json[kNCreationTS],
        isRead: (json[kNIsRead] as bool).obs,
        type: json[kNType],
      );

  Map<String, dynamic> toJson() => {
        kNTitle: title,
        kNBody: body,
        kNSessionAccessToken: sessionAccessToken,
        kNUserId: userId,
        kNCreationTS: creationTS,
        kNIsRead: isRead,
        kNType: type,
      };
}
