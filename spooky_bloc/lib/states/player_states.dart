import 'package:equatable/equatable.dart';

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
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final bool isPlaying;

  const PlayingState({
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.isPlaying,
  });

  @override
  List<Object> get props => [currentIndex, duration, position, isPlaying];

  PlayingState copy({
    int? currentIndex,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
  }) {
    return PlayingState(
      currentIndex: currentIndex ?? this.currentIndex,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
