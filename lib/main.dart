import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? choice;
  FlutterMidi flutterMidi = FlutterMidi();
  @override
  void initState() {
    load('assets/Guitars.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: _byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: DropdownButton<String?>(
              value: choice ?? 'Guitars',
              items: const [
                DropdownMenuItem(
                  child: Text('Guitar'),
                  value: 'Guitars',
                ),
                DropdownMenuItem(
                  child: Text('Strings'),
                  value: 'Strings',
                ),
                DropdownMenuItem(
                  child: Text('Piano'),
                  value: 'Yamaha-Grand',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  choice = value;
                });

                load('assets/$choice.sf2');
              }),
        ),
        leadingWidth: 124,
        title: Text('piano'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.sms),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.email),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
          child: InteractivePiano(
        highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 60,
        noteRange: NoteRange.forClefs([
          Clef.Treble,
        ]),
        onNotePositionTapped: (position) {
          // Use an audio library like flutter_midi to play the sound
          flutterMidi.playMidiNote(midi: position.pitch);
        },
      )),
    );
  }
}
