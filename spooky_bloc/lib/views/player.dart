import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spooky_bloc/events/player_events.dart';
import 'package:spooky_bloc/states/player_states.dart';
import 'package:spooky_bloc/views/progress_slider.dart';
import 'package:spooky_bloc/views/swiper.dart';

import '../blocs/player_bloc.dart';
import '../models/audio_item.dart';

class Player extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const Player({super.key, required this.audioPlayer});

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  final List<AudioItem> audioList = [
    AudioItem(
      "allthat.mp3",
      "All that",
      "Mayelo",
      "assets/allthat_colored.jpg",
    ),
    AudioItem("love.mp3", "Love", "Diego", "assets/love_colored.jpg"),
    AudioItem(
      "thejazzpiano.mp3",
      "Jazz Piano",
      "Jazira",
      "assets/thejazzpiano_colored.jpg",
    ),
  ];
  PlayerBloc? bloc;

  int? currentIndex;
  Color? wormColor;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    bloc = PlayerBloc(audioPlayer: widget.audioPlayer, canciones: audioList);
    bloc?.add(LoadingEvent(index: 0));
    currentIndex = 0;
    wormColor = const Color(0xffda1cd2);
    pageController = PageController(viewportFraction: .8);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc!,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Swiper(
                pageController: pageController!,
                audioList: audioList,
                color: wormColor!,
                bloc: bloc!,
              ),
              BlocBuilder<PlayerBloc, PlayState>(
                  builder: (context, state) {
                    Duration position = Duration.zero;
                    Duration duration = Duration.zero;

                    if (state is PlayingState) {
                      position = state.position;
                      duration = state.duration;
                    }

                    return ProgressSlider(
                      position: position,
                      duration: duration,
                      seek: (newpos) {
                        bloc?.add(SeekEvent(position: newpos));
                      },
                      color: wormColor!,
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}