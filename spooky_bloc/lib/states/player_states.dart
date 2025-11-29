import 'package:equatable/equatable.dart';

import '../models/audio_item.dart';

abstract class PlayState extends Equatable {
  const PlayState();

  @override
  List<Object> get props => [];
}

class IniState extends PlayState {}

class LodingState extends PlayState {}

class ErrorState extends PlayState {
  final String error;
  const ErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class PlayingState extends PlayState {

  final List<AudioItem> playlist;
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final double volume;
  final double pitch;
  final int playlistLength;

  const PlayingState({
    required this.playlist,
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.isPlaying,
    this.volume = 1.0,
    this.pitch = 1.0,
    this.playlistLength = 0,
  });

  PlayingState copy({
    List<AudioItem>? playlist,
    int? currentIndex,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    double? volume,
    double? pitch,
    int? playlistLength,
  }) {
    return PlayingState(
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
    );
  }

  @override
  List<Object> get props => [playlist, currentIndex, duration, position, isPlaying, volume, pitch];
}