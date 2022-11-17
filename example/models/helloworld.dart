import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class Root {
  Root({
    this.id,
    this.name,
    this.shortname,
    this.sirioperatorref,
    this.timezone,
    this.defaultlanguage,
    this.contacttelephonenumber,
    this.website,
    this.primarymode,
    this.privatecode,
    this.monitored,
    this.othermodes,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
    id: asT<String?>(json['Id']),
    name: asT<String?>(json['Name']),
    shortname: asT<String?>(json['ShortName']),
    sirioperatorref: asT<Object?>(json['SiriOperatorRef']),
    timezone: asT<String?>(json['TimeZone']),
    defaultlanguage: asT<String?>(json['DefaultLanguage']),
    contacttelephonenumber: asT<Object?>(json['ContactTelephoneNumber']),
    website: asT<Object?>(json['WebSite']),
    primarymode: asT<String?>(json['PrimaryMode']),
    privatecode: asT<String?>(json['PrivateCode']),
    monitored: asT<bool?>(json['Monitored']),
    othermodes: asT<String?>(json['OtherModes']),
  );

  String? id;
  String? name;
  String? shortname;
  Object? sirioperatorref;
  String? timezone;
  String? defaultlanguage;
  Object? contacttelephonenumber;
  Object? website;
  String? primarymode;
  String? privatecode;
  bool? monitored;
  String? othermodes;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': id,
    'Name': name,
    'ShortName': shortname,
    'SiriOperatorRef': sirioperatorref,
    'TimeZone': timezone,
    'DefaultLanguage': defaultlanguage,
    'ContactTelephoneNumber': contacttelephonenumber,
    'WebSite': website,
    'PrimaryMode': primarymode,
    'PrivateCode': privatecode,
    'Monitored': monitored,
    'OtherModes': othermodes,
  };
}
