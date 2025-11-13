import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spooky_bloc/views/player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer? audioPlayer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer!.setReleaseMode(ReleaseMode.stop);
  }
  @override
  Widget build(BuildContext context) {
    return Player( audioPlayer: audioPlayer!,);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer!.dispose();
    super.dispose();
  }
}
