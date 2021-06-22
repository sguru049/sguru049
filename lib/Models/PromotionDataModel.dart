import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionDataModel {
  DocumentReference? docRef;
  DocumentReference? id;
  String? city;
  bool? queued;
  String? cityState;

  PromotionDataModel(
      {this.docRef, this.id, this.queued, this.city, this.cityState});

  factory PromotionDataModel.fromJson(
          DocumentSnapshot element, Map<String, dynamic> json) =>
      PromotionDataModel(
          docRef: element.reference,
          id: json[kpId],
          queued: json[kpQueued],
          city: json[kpCity],
          cityState: json[kpCityState]);

  Map<String, dynamic> toJson() =>
      {kpId: id, kpQueued: queued, kpCity: city, kpCityState: cityState};
}
