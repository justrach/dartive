<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->


## Features

A fast and easy server architecture for Dart. Seamlessly integrate with your existing codebase.
Models can be used as a data layer for your application, or as a server for your Flutter app.


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

In order to run a RESTFUL server all you have to do is create a model and extend it with the `Model` class.
and follow the following code and your server would be running on port 8080.

```dart
void main(List<String> arguments) async{
  Dartive.get('/', () {
    print("This is running");
    return 'return new';
  });
  

  Dartive.post('/some.json', (Dartive api) async {
    var  body = api.request;
    // you have to change the way that the request is parsed. this can be done by using models
    // or by using the request.body property
    var x = json
        .decode(body)
        .map((data) => Root.fromJson(data))
        .toList();
    List<Root> streetsList = List<Root>.from(x);
    print(streetsList);

    return    streetsList[0];;
  });
  await Dartive.listen(host: '0.0.0.0', port: 8080);
}
```



# To add ORM support for post requests.
