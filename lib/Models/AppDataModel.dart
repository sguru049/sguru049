import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDataModel {
  bool? virtualConsultation;
  DocumentReference? docRef;
  String? docId;
  String? name;
  double? rating;
  String? address;
  String? contact;
  num? latitude;
  num? longitude;
  String? websiteUrl;
  String? city;
  String? state;
  Map<String, dynamic>? socialLinks;
  String? zipCode;
  String? imageUrl;
  String? emailAddress;
  DocumentReference? subscription;
  String? cityState;
  String? geoHash;

  AppDataModel({
    this.virtualConsultation,
    this.address,
    this.city,
    this.contact,
    this.docId,
    this.docRef,
    this.latitude,
    this.longitude,
    this.name,
    this.rating,
    this.socialLinks,
    this.state,
    this.websiteUrl,
    this.zipCode,
    this.imageUrl,
    this.emailAddress,
    this.subscription,
    this.cityState,
    this.geoHash,
  });

  factory AppDataModel.fromJson(
          DocumentSnapshot element, Map<String, dynamic> json) =>
      // factory AppDataModel.fromJson(Map<String, dynamic> json) =>
      AppDataModel(
        docRef: element.reference,
        docId: element.id,
        virtualConsultation: json[kVirtualConsultation] ?? false,
        name: json[kName],
        address: json[kAddress] ?? '',
        latitude: double.tryParse('${json[kLatitude]}') ?? 0.0,
        longitude: double.tryParse('${json[kLongitude]}') ?? 0.0,
        contact: json[kContact] ?? '',
        websiteUrl: json[kWebsiteUrl] ?? '',
        city: json[kCity] ?? '',
        state: json[kState] ?? '',
        socialLinks: json[kSocialLinks],
        imageUrl: json[kImageUrl] ?? '',
        zipCode: json[kZipCode] ?? '',
        emailAddress: json[kEmailAddress] ?? '',
        subscription: json[kSubscription] ?? null,
        geoHash: json[kGeoHash],
        cityState: json[kCityState] ?? '',
      );

  Map<String, dynamic> toJson() => {
        kVirtualConsultation: virtualConsultation,
        kName: name,
        kAddress: address,
        kLatitude: latitude,
        kLongitude: longitude,
        kContact: contact,
        kWebsiteUrl: websiteUrl,
        kCity: city,
        kState: state,
        kSocialLinks: socialLinks,
        kImageUrl: imageUrl,
        kZipCode: zipCode,
        kEmailAddress: emailAddress,
        kSubscription: subscription,
        kGeoHash: geoHash,
        kCityState: cityState
      };
}
