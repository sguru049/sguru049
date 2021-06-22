import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinnerModel {
  DocumentReference? docRef;
  String? sessionAccessToken;
  Timestamp? wonOn;
  String? winnerName;
  int? winnerNumber;
  bool? isMailSent;
  String? email;
  String? phoneNo;

  WinnerModel({
    this.docRef,
    this.sessionAccessToken,
    this.winnerName,
    this.winnerNumber,
    this.isMailSent,
    this.wonOn,
    this.email,
    this.phoneNo,
  });

  factory WinnerModel.fromJson(
          DocumentReference documentReference, Map<String, dynamic> json) =>
      WinnerModel(
        docRef: documentReference,
        sessionAccessToken: json[kWSessionAccessToken],
        winnerName: json[kWName],
        winnerNumber: json[kWVisitorCount],
        isMailSent: json[kWIsMailSent],
        wonOn: json[kWWonOn],
        email: json[kWEmail],
        phoneNo: json[kWPhone],
      );

  Map<String, dynamic> toJson() => {
        kNSessionAccessToken: sessionAccessToken,
        kWName: winnerName,
        kWVisitorCount: winnerNumber,
        kWIsMailSent: isMailSent,
        kWWonOn: wonOn,
        kWEmail: email,
        kWPhone: phoneNo
      };
}
