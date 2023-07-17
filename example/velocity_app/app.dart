import 'dart:convert';

import 'package:dartive/dartive.dart';
import 'package:flutter/foundation.dart';

import '../models/helloworld.dart';

void main(List<String> arguments) async{
  Dartive.get('/', () {
  return 'return old';
  //test
  });
// added new items

  Dartive.get('/busInformation', () {

    return {
      "Id": "5E",
      "Name": "511 Emergency",
      "ShortName": "511 Emergency",
      "SiriOperatorRef": null,
      "TimeZone": "America/Vancouver",
      "DefaultLanguage": "en",
      "ContactTelephoneNumber": null,
      "WebSite": null,
      "PrimaryMode": "other",
      "PrivateCode": "5E",
      "Monitored": true,
      "OtherModes": ""
    };
  });
  // Dartive.post('/some.json', (Dartive api) async {
  //   return ArgumentError('o');
  // });
  Dartive.post('/some.json', (Dartive api) async {
   var  body = api.request;
    // you have to change the way that the request is parsed. this can be done by using models
    // or by using the request.body property
    var x = json
        .decode(body)
        .map((data) => Root.fromJson(data))
        .toList();
   List<Root> streetsList = List<Root>.from(x);
   if (kDebugMode) {
     print(streetsList);
   }

        return    streetsList[0];
  });
  await Dartive.listen(host: '0.0.0.0', port: 8080);
  }
