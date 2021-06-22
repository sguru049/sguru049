import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DealModel {
  DocumentReference? id;
  Timestamp? creationTS;
  String? title;
  String? code;
  Timestamp? expiryTS;
  String? dealId;

  DealModel({
    this.dealId,
    this.id,
    this.creationTS,
    this.title,
    this.code,
    this.expiryTS,
  });

  factory DealModel.fromJson(String dealId, Map<String, dynamic> json) =>
      DealModel(
        dealId: dealId,
        id: json[kDId],
        creationTS: json[kDCreationTS],
        title: json[kDTitle],
        code: json[kDCode] ?? null,
        expiryTS: json[kDExpiryTS] ?? null,
      );

  Map<String, dynamic> toJson() => {
        kDId: id,
        kDCreationTS: creationTS,
        kDTitle: title,
        kDCode: code,
        kDExpiryTS: expiryTS,
      };
}
