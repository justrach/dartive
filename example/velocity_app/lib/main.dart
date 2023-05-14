// this is a local terminal app to demonstrate that you can use dartive to create a terminal app! and run it locally, the main repository for this would be at https://github.com/justrach/velocity 

//TODO: A

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartive/dartive.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(const VelocityDart());
  Dartive.post('/', (Dartive api) async {
    var body = api.request;
    return body;
  });
  await Dartive.listen(host: '0.0.0.0', port: 8080);
}

class VelocityDart extends StatelessWidget {
  const VelocityDart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal Emulator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const TerminalHomePage(title: 'Terminal Emulator'),
    );
  }
}

class TerminalHomePage extends StatefulWidget {
  const TerminalHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  TerminalHomePageState createState() => TerminalHomePageState(); 
}

class TerminalHomePageState extends State<TerminalHomePage> {
  final _controller = TextEditingController();
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _output,
                style: GoogleFonts.sourceCodePro(
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          TextField(
            controller: _controller,
            onSubmitted: _handleCommand,
            style: GoogleFonts.sourceCodePro(
              textStyle: const TextStyle(color: Colors.white),
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter command',
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCommand(String command) async {
    _controller.clear();
    var response = await http.post(
      Uri.parse('http://localhost:8080'),
      body: command,
    );
    setState(() {
      _output += response.body;
    });
  }
}
