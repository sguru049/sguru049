class OtherDataEntryModel {
  bool? isPromoted;
  String? name;
  num? rating;
  String? address;
  String? contact;
  Map<String, dynamic>? location;
  num? latitude;
  num? longitude;
  String? websiteUrl;
  String? city;
  String? state;
  SocialLinks? socialLinks;
  //
  String? zipCode;
  String? imageUrl;
  bool? virtualConsultation;
  String? emailAddress;

  OtherDataEntryModel(
      {this.isPromoted,
      this.city,
      this.name,
      this.latitude,
      this.longitude,
      this.socialLinks,
      this.address,
      this.state,
      this.contact,
      this.websiteUrl,
      this.rating,

      //
      this.zipCode,
      this.imageUrl,
      this.virtualConsultation,
      this.emailAddress});

  factory OtherDataEntryModel.fromJson(Map<String, dynamic> json) =>
      OtherDataEntryModel(
        isPromoted: false,
        rating: double.tryParse('${json["rating"]}'),
        name: json["name"],
        // address: (json["address"].split(',').length == 3)
        //     ? json["name"]
        //     : json["address"].split(',').first ?? '',
        address: json["address"],
        latitude: double.tryParse('${json["location"]['lat']}') ?? null,
        longitude: double.tryParse('${json["location"]['lng']}') ?? null,
        contact: json["contact"] ?? '',
        websiteUrl: json["website"] ?? '',
        city: json["city"] ?? '',
        state: json["state"] ?? '',
        socialLinks: SocialLinks.fromJson(json['social_links']),
        //
        imageUrl: json["ImageURL"] ?? null,
        zipCode: json["ZipCode"] ??
            json["address"].split(',').reversed.toList()[1].split(' ').last,
        virtualConsultation: json['VirtualConsultation'] ?? false,
        emailAddress: json["EmailAddress"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'name': name,
        'address;': address,
        'contact': contact,
        'location': location,
        'lat': latitude,
        'lng': longitude,
        'website': websiteUrl,
        'city': city,
        'state': state,
        'social_links': socialLinks,
        //
        'ZipCode': zipCode,
        'ImageURL': imageUrl,
        'VirtualConsultation': virtualConsultation,
        'EmailAddress': emailAddress,
      };
}

class SocialLinks {
  List<String>? facebook;
  List<String>? twitter;
  List<String>? linkedin;
  List<String>? youtube;
  List<String>? instagram;
  List<String>? yelp;
  List<String>? blogspot;
  List<String>? snapchat;

  SocialLinks(
      {this.blogspot,
      this.facebook,
      this.instagram,
      this.linkedin,
      this.snapchat,
      this.twitter,
      this.yelp,
      this.youtube});

  factory SocialLinks.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SocialLinks();
    return SocialLinks(
      blogspot: (json['blogspot'] != null)
          ? (json['blogspot'] as List).map((e) => '$e').toList()
          : [],
      facebook: (json['facebook'] != null)
          ? (json['facebook'] as List).map((e) => '$e').toList()
          : [],
      instagram: (json['instagram'] != null)
          ? (json['instagram'] as List).map((e) => '$e').toList()
          : [],
      linkedin: (json['linkedin'] != null)
          ? (json['linkedin'] as List).map((e) => '$e').toList()
          : [],
      snapchat: (json['snapchat'] != null)
          ? (json['snapchat'] as List).map((e) => '$e').toList()
          : [],
      twitter: (json['twitter'] != null)
          ? (json['twitter'] as List).map((e) => '$e').toList()
          : [],
      yelp: (json['yelp'] != null)
          ? (json['yelp'] as List).map((e) => '$e').toList()
          : [],
      youtube: (json['youtube'] != null)
          ? (json['youtube'] as List).map((e) => '$e').toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'blogspot': blogspot,
        'facebook': facebook,
        'instagram': instagram,
        'linkedin': linkedin,
        'snapchat': snapchat,
        'twitter': twitter,
        'yelp': yelp,
        'youtube': youtube,
      };
}
