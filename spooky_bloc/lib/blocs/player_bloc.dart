import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:spooky_bloc/services/database_helper.dart';
import '../events/player_events.dart';
import '../models/audio_item.dart';
import '../states/player_states.dart';

class PlayerBloc extends Bloc<PlayerEvents, PlayState> {
  final AudioPlayer audioPlayer;

  StreamSubscription? duracion, posicion, estado;

  PlayerBloc({required this.audioPlayer})
      :
        super(IniState()) {
    on<LoadingEvent>(loading);
    on<PlayingEvent>(playing);
    on<PlayingPauseEvent>(playingPause);
    on<NextEvent>(next);
    on<PreviousEvent>(previous);
    on<SeekEvent>(seek);
    on<ChangeVolumeEvent>(_onChangeVolume);
    on<ChangePitchEvent>(_onChangePitch);
    on<UpdatePositionEvent>(_onUpdatePosition);
    on<UpdateDurationEvent>(_onUpdateDuration);
    //on<AddInternetTrackEvent>(_onAddInternetTrackEvent);
    on<InitializePlayerEvent>(_onInitializePlayer);


    setup();
  }

  //cargar la bd y canciones ahshahda
  Future<void> _onInitializePlayer(
      InitializePlayerEvent event, Emitter<PlayState> emit) async {
    print("Cargando canciones...");
    debugPrint("cargandocanciones...");
    emit(LodingState());

    try{
      final dataBaseResult = await DatabaseHelper.instance.read();
      debugPrint("datos: $dataBaseResult");
      final List <AudioItem> listaConvertida = dataBaseResult.map((e) => AudioItem(e.assetPath, e.title, e.artist, e.imagePath)).toList();

      emit(PlayingState(
          playlist: listaConvertida,
          currentIndex: 0,
          duration: Duration.zero,
          position: Duration.zero,
          isPlaying: false,
          playlistLength: listaConvertida.length,
      ));
      add(LoadingEvent(index: 0));
    } catch (errorE){
      emit(ErrorState(error: errorE.toString()));
      debugPrint("Error cargando canciones: $errorE");
    }
  }
  // Future<void> _onAddInternetTrackEvent(
  //     AddInternetTrackEvent event, Emitter<PlayState> emit) async {
  //   cancionesInternet.add(event.track);
  //   debugPrint("Se agregó la canción con éxito.");
  //
  //   if (state is PlayingState) {
  //     final PlayingState actual = state as PlayingState;
  //     emit(actual.copy(playlistLength: playList.length));
  //   } else {
  //     if (state is IniState) {
  //       add(const LoadingEvent(index: 0));
  //     }
  //   }
  // }

  Future<void> _onChangeVolume(
      ChangeVolumeEvent event, Emitter<PlayState> emit) async {
    await audioPlayer.setVolume(event.volume);

    if (state is PlayingState) {
      final actual = state as PlayingState;
      emit(actual.copy(volume: event.volume));
    }
  }

  Future<void> _onChangePitch(
      ChangePitchEvent event, Emitter<PlayState> emit) async {
    await audioPlayer.setPlaybackRate(event.pitch);

    if (state is PlayingState) {
      final actual = state as PlayingState;
      emit(actual.copy(pitch: event.pitch));
    }
  }

  Future<void> loading(LoadingEvent event, Emitter<PlayState> emit) async {
    List<AudioItem> listaActual = [];
    if (state is PlayingState) {
      listaActual = (state as PlayingState).playlist;
    }
    if (listaActual.isEmpty) return;
    try {
      emit(LodingState());
      await audioPlayer.stop();

      final track = listaActual[event.index];

      await audioPlayer.setVolume(1.0);
      await audioPlayer.setPlaybackRate(1.0);

      if (track is AudioItem) {
        await audioPlayer.setSource(AssetSource(track.assetPath));

        emit(
          PlayingState(
            playlist: listaActual,
            currentIndex: event.index,
            duration: Duration.zero,
            position: Duration.zero,
            isPlaying: false,
            volume: 1.0,
            pitch: 1.0,
            playlistLength: listaActual.length,
          ),
        );
        add(PlayingEvent());
      }
      debugPrint('Loading song index: ${event.index}');
    } catch (e) {
      debugPrint(e.toString());
      emit(ErrorState(error: "Error: Audio no cargado"));
    }
  }

  Future<void> playing(PlayingEvent event, Emitter<PlayState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.resume();
        final PlayingState actual = state as PlayingState;
        emit(actual.copy(isPlaying: true));
      } catch (e) {
        debugPrint(e.toString());
        emit(ErrorState(error: "Error: Audio no se pudo reproducir"));
      }
    }
  }

  Future<void> playingPause(
      PlayingPauseEvent event,
      Emitter<PlayState> emit,
      ) async {
    if (state is PlayingState) {
      final PlayingState actual = state as PlayingState;
      try {
        if (actual.isPlaying) {
          await audioPlayer.pause();
          emit(actual.copy(isPlaying: false));
        } else {
          await audioPlayer.resume();
          emit(actual.copy(isPlaying: true));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(ErrorState(error: "Error: No se pudo pausar/reanudar"));
      }
    }
  }

  Future<void> next(NextEvent event, Emitter<PlayState> emit) async {
    if (state is PlayingState) {
      final PlayingState actual = state as PlayingState;
      final nextIndex = (actual.currentIndex + 1) % actual.playlist.length;
      add(LoadingEvent(index: nextIndex));
    }
  }

  Future<void> previous(PreviousEvent event, Emitter<PlayState> emit) async {
    if (state is PlayingState) {
      final PlayingState actual = state as PlayingState;
      final previousIndex =
          (actual.currentIndex - 1 + actual.playlist.length) % actual.playlist.length;
      add(LoadingEvent(index: previousIndex));
    }
  }

  Future<void> seek(SeekEvent event, Emitter<PlayState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.seek(event.position);
        final PlayingState actual = state as PlayingState;
        emit(actual.copy(position: event.position));
      } catch (e) {
        debugPrint(e.toString());
        emit(ErrorState(error: "Error: No se pudo buscar la posición"));
      }
    }
  }

  Future<void> _onUpdatePosition(
      UpdatePositionEvent event,
      Emitter<PlayState> emit,
      ) async {
    if (state is PlayingState) {
      final actual = state as PlayingState;

      if (actual.duration.inSeconds == 0 && event.position.inSeconds > 0) {
        final d = await audioPlayer.getDuration();
        if (d != null && d.inSeconds > 0) {
          add(UpdateDurationEvent(duration: d));
        }
      }

      emit(actual.copy(position: event.position));
    }
  }

  Future<void> _onUpdateDuration(
      UpdateDurationEvent event,
      Emitter<PlayState> emit,
      ) async {
    if (state is PlayingState) {
      final actual = state as PlayingState;
      emit(actual.copy(duration: event.duration));
    }
  }

  void setup() {
    estado = audioPlayer.onPlayerStateChanged.listen((event) {
      if (state is PlayingState) {
        final PlayingState actual = state as PlayingState;
        if (event == PlayerState.playing && !actual.isPlaying) {
          add(PlayingEvent());

          audioPlayer.getDuration().then((d) {
            if (d != null) add(UpdateDurationEvent(duration: d));
          });

        } else if (event == PlayerState.paused && actual.isPlaying) {
          add(PlayingPauseEvent());
        } else if (event == PlayerState.completed) {
          add(NextEvent());
        }
      }
    });

    posicion = audioPlayer.onPositionChanged.listen((position) {
      add(UpdatePositionEvent(position: position));
    });

    duracion = audioPlayer.onDurationChanged.listen((duration) {
      add(UpdateDurationEvent(duration: duration));
    });
  }

  @override
  Future<void> close() {
    duracion?.cancel();
    posicion?.cancel();
    estado?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}