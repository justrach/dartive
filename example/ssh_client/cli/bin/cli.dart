import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';

void main() {
  stdout.writeln("Enter IP Address:");
  String? ip = stdin.readLineSync();

  stdout.writeln("Enter port number:");
  int? port = int.parse(stdin.readLineSync()!);

  stdout.writeln("Enter username:");
  String? username = stdin.readLineSync();

  stdout.writeln("Enter password:");
  String? password = stdin.readLineSync();

  // Create a new isolate and run the tunnel function inside it.
  Isolate.spawn(tunnel, [ip, port, username, password]);
}

void tunnel(List<dynamic> params) async {
  String ip = params[0];
  int port = params[1];
  String username = params[2];
  String password = params[3];

  try {
    final client = SSHClient(
      await SSHSocket.connect(ip, port),
      username: username,
      onPasswordRequest: () => password,
    );

    stdout.writeln("Connected to the server");

    final shell = await client.shell();
    stdout.addStream(shell.stdout);
    stderr.addStream(shell.stderr);
    stdin.cast<Uint8List>().listen(shell.write);

    await shell.done;
    client.close();
  } catch (e) {
    stdout.writeln("Failed to connect to the server: $e");
  }
}