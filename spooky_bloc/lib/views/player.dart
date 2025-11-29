import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spooky_bloc/events/player_events.dart';
import 'package:spooky_bloc/states/player_states.dart';
import 'package:spooky_bloc/views/config_audio.dart';
import 'package:spooky_bloc/views/controles.dart';
import 'package:spooky_bloc/views/progress_slider.dart';
import 'package:spooky_bloc/views/swiper.dart';

import '../blocs/player_bloc.dart';
import '../models/audio_item.dart';
import 'artist.dart';
import 'menu_drawer.dart';

class Player extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const Player({super.key, required this.audioPlayer});

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  PlayerBloc? bloc;
  int currentIndex = 0;
  Color? wormColor;
  PageController? pageController;

  List<AudioItem> _cachedList = [];

  @override
  void initState() {
    super.initState();
    bloc = PlayerBloc(audioPlayer: widget.audioPlayer);
    bloc?.add(InitializePlayerEvent());
    wormColor = const Color(0xFF0B2E33);
    pageController = PageController(viewportFraction: .9);
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: bloc!,
        child: const ConfigAudio(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0B2E33);

    return BlocProvider.value(
      value: bloc!,
      child: Scaffold(
        backgroundColor: const Color(0xFFB8E3E9),
        drawer: Drawer(
          width: 280,
          child: MenuDrawer(
            primaryColor: primaryColor,
            onSettingsTap: _showSettingsModal,
          ),
        ),
        appBar: AppBar(
          title: const Text("Spooky :)", style: TextStyle(fontFamily: "DMSerif", fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff7fa3a9),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: primaryColor),
              onPressed: _showSettingsModal,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<PlayerBloc, PlayState>(
                  buildWhen: (prev, curr) {
                    return (curr is PlayingState) || (curr is LodingState && _cachedList.isEmpty);
                  },
                  builder: (context, state) {
                    if (state is PlayingState) {
                      _cachedList = state.playlist;
                    }

                    if (_cachedList.isNotEmpty) {
                      return Center(
                        child: AspectRatio(
                          aspectRatio: 1 / pageController!.viewportFraction,
                          child: Swiper(
                            pageController: pageController!,
                            audioList: _cachedList,
                            color: primaryColor,
                            onPageChanged: (index) {
                              currentIndex = index;
                              bloc?.add(LoadingEvent(index: index));
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: BlocBuilder<PlayerBloc, PlayState>(
                  builder: (context, state) {
                    String title = "Cargando...";
                    String artist = "";

                    if (state is PlayingState) {
                      if (state.playlist.isNotEmpty) {
                        final currentItem = state.playlist[state.currentIndex];
                        title = currentItem.title;
                        artist = currentItem.artist;
                      }
                      if (state.currentIndex != currentIndex) {
                        currentIndex = state.currentIndex;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (pageController?.hasClients ?? false) {
                            pageController?.jumpToPage(currentIndex);
                          }
                        });
                      }
                    }
                    return Artist(
                      artist: artist,
                      name: title,
                    );
                  },
                ),
              ),
              BlocBuilder<PlayerBloc, PlayState>(
                builder: (context, state) {
                  Duration position = Duration.zero;
                  Duration duration = Duration.zero;
                  bool isPlaying = false;

                  if (state is PlayingState) {
                    position = state.position;
                    duration = state.duration;
                    isPlaying = state.isPlaying;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgressSlider(
                        position: position,
                        duration: duration,
                        seek: (newpos) => bloc?.add(SeekEvent(position: newpos)),
                        color: primaryColor,
                      ),
                      Controles(
                        play: () {
                          int playingIndex = -1;
                          if (state is PlayingState) playingIndex = state.currentIndex;

                          if (currentIndex != playingIndex) {
                            bloc?.add(LoadingEvent(index: currentIndex));
                          } else if (isPlaying) {
                            bloc?.add(PlayingPauseEvent());
                          } else {
                            bloc?.add(PlayingEvent());
                          }
                        },
                        next: () => bloc?.add(NextEvent()),
                        previous: () => bloc?.add(PreviousEvent()),
                        playing: isPlaying,
                        position: position,
                        duration: duration,
                        color: primaryColor,
                        progressPercent: duration.inMilliseconds > 0
                            ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
                            : 0.0,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}