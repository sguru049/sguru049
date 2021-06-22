import 'package:beauty_spin/Constants/KeysConstants.dart';

class CityDataModel {
  String? city;
  String? state;
  num? latitude;
  num? longitude;
  String? geoHash;
  String? cityState;

  CityDataModel({
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.geoHash,
    this.cityState,
  });

  factory CityDataModel.fromJson(Map<String, dynamic> json) => CityDataModel(
      city: json[kcCity],
      state: json[kcState],
      latitude: json[kcLatitude],
      longitude: json[kcLongitude],
      geoHash: json[kcGeoHash],
      cityState: json[kcCityState]);

  Map<String, dynamic> toJson() => {
        kcCity: city,
        kcState: state,
        kcLatitude: latitude,
        kcLongitude: longitude,
        kcGeoHash: geoHash,
        kcCityState: cityState
      };
}
