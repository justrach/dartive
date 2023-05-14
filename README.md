# [Dartive](https://pub.dev/packages/dartive)
Dartive is an ExpressJS-like wrapper for Dart backend, simplifying the process of defining routes and handling HTTP requests.

# Features
* **Route Handling**: Define GET , POST, PUT , DELETE and other routes easily and intuitively.
* **Request Parsing**: Parse incoming request bodies using built-in JSON decoding and custom data models.
* **Server Configuration**: Customize your server host and port with a single line of code.


# Installation
Include Dartive in your pubspec.yaml under dependencies:
```bash
dependencies:
  dartive: ^version

```
Then, run `dart pub get` to fetch the package.

# Usage
## Basic Usage
```dart
import 'package:dartive/dartive.dart';

void main(List<String> arguments) {
  Dartive.get('/', () {
    return {'message': 'Hello, world!'};
  });

  Dartive.listen(host: '0.0.0.0', port: 8080);
}
```
## Using Models for Request Parsing
```dart
import 'dart:convert';
import 'package:dartive/dartive.dart';
import 'models/myModel.dart';

void main(List<String> arguments) {
  Dartive.post('/myEndpoint', (Dartive api) async {
    var body = api.request;
    var parsedData = json.decode(body).map((data) => MyModel.fromJson(data)).toList();
    List<MyModel> modelList = List<MyModel>.from(parsedData);
    return modelList[0];
  });

  Dartive.listen(host: '0.0.0.0', port: 8080);
}
```

# Running Dartive with Dartivemon
You can run the back and front end, coupled with hot reloading with [Dartivemon](https://pub.dev/packages/dartivemon)!
To run Dartive with Dartivemon, use the command `dartivemon be [nameofapp.dart]`. This command runs the server on a specific folder.


# Recommended File Structure(FeBe)

## What is FeBe?
FEBE (FrontEnd BackEnd) is a unified framework that simplifies development across multiple platforms - iOS, Android, Web (WASM), Linux, and Windows - using Dart and Flutter. By structuring your project according to the FEBE framework, you can maintain a single code base for both the backend and frontend, reducing redundancy and improving maintainability.


## Single Source of Truth for Models
One of the core benefits of the FEBE framework is that it eliminates the need to maintain separate models for the backend and frontend. Traditionally, you might define one set of models for your backend, and another set for your frontend, duplicating effort and introducing potential inconsistencies.

FEBE solves this by enabling you to define your data models once and use them across your entire app. This not only reduces the amount of code you have to write, but also ensures consistency and accuracy across your application.
## Multiplatform Development
Developing applications that run on multiple platforms (iOS, Android, Web, Linux, Windows) has traditionally been a complex and time-consuming process, often requiring separate code bases for each platform.

FEBE simplifies this process by leveraging the capabilities of Dart and Flutter to build multiplatform apps from a single code base. This means you can write your code once, and then compile and deploy it across all supported platforms, saving time and effort.
# Dartive and Dartivemon
FEBE integrates with Dartive, an ExpressJS-like wrapper for Dart backend, and Dartivemon, a tool that runs Dart and Flutter applications concurrently and watches for changes in your Dart application to automatically restart it.
## File Structure
```bash
root
├── example
│   ├── flutter_app
│   ├── model
│   ├── app.dart (run with dartivemon app.dart)
│   └── lib
│       └── main.dart (runs with just dartivemon app.dart or flutter run)
```
# Running FEBE with Dartivemon
To run your FEBE application with Dartivemon, use the command dartivemon be [nameofapp.dart]. This command runs the server on a specific folder.
# Notes
Make sure to replace '0.0.0.0' and 8080 with your desired server host and port, respectively.
You can define as many routes as needed using Dartive's get and post methods.
Use the listen method to start the server after defining your routes.
