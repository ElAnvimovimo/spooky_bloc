import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/src/audioplayer.dart';
import 'package:spooky_bloc/events/player_events.dart';
import 'package:spooky_bloc/models/audio_item.dart';
import 'package:spooky_bloc/states/player_states.dart';

class PlayerBloc extends Bloc<PlayerEvents, PlayState> {
  final AudioPlayer audioPlayer;
  final List<AudioItem> canciones;
  StreamSubscription? duracion, posicion, estado;

  PlayerBloc({required this.audioPlayer, required this.canciones})
    : super(IniState()) {
    on<LoadingEvent>(loading);
    on<PlayingEvent>(playing);
    on<PlayingPauseEvent>(playingPause);
    on<NextEvent>(next);
    on<PreviousEvent>(previous);
    on<SeekEvent>(seek);
    setup();
  }

  Future<void> loading(LoadingEvent event, Emitter<PlayState> emit) async {
    try {
      emit(LodingState());
      await audioPlayer?.stop();
      await audioPlayer?.setSourceAsset(canciones[event.index].assetPath);

      emit(
        PlayingState(
          currentIndex: event.index,
          duration: Duration.zero,
          position: Duration.zero,
          isPlaying: false,
        ),

      );
      debugPrint(event.index.toString());
      add(PlayingEvent()); //reproduccion automatica
    } catch (e) {
      debugPrint(e.toString());
      emit(ErrorState(error: "Error: Audio no cargado"));
    }
  }

  Future<void> playing(PlayingEvent event, Emitter<PlayState> emit) async {
     if (state is PlayingState){
       try {
          await audioPlayer?.resume();
          //necesito clonar el estado
         final  PlayingState actual = state as  PlayingState; //downcasting
         emit(actual.copy(isPlaying: true));

       }catch(e){
         debugPrint(e.toString());
         emit(ErrorState(error: "Error: Audio no se pudo reproducir"));
       }
     }
  }
  Future<void> playingPause(
    PlayingPauseEvent event,
    Emitter<PlayState> emit,
  ) async {}
  Future<void> next(NextEvent event, Emitter<PlayState> emit) async {}
  Future<void> previous(PreviousEvent event, Emitter<PlayState> emit) async {}
  Future<void> seek(SeekEvent event, Emitter<PlayState> emit) async {}

  void setup() {

    estado = audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing){
        if (state == PlayState){
          final  PlayingState actual = state as  PlayingState;
          if (!actual.isPlaying){
            add(PlayingEvent());
          }
        }
      }else {
        if (event == PlayerState.paused){
          if (event == PlayerState.playing){
            final  PlayingState actual = state as  PlayingState;
            if (actual.isPlaying){
              add(PlayingPauseEvent());
            }
          }
        }
      }
    },);

    posicion = audioPlayer.onPositionChanged.listen((event) {
      if (state == PlayerState.playing){
        final   actual = state as  PlayingState;
        emit(actual.copy(position: event)  );
      }
    },);


    duracion = audioPlayer.onDurationChanged.listen((event) {
      if (state == PlayerState.playing){
        final   actual = state as  PlayingState;
        emit(actual.copy(duration: event) );
      }
    },);


  }
}
