import 'package:equatable/equatable.dart';

import '../models/audio_track.dart';

abstract class PlayerEvents extends Equatable {
  const PlayerEvents();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends PlayerEvents {
  final int index;

  const LoadingEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class PlayingEvent extends PlayerEvents {}

class PlayingPauseEvent extends PlayerEvents {}

class NextEvent extends PlayerEvents {}

class PreviousEvent extends PlayerEvents {}

class SeekEvent extends PlayerEvents {
  final Duration position;

  const SeekEvent({required this.position});

  @override
  List<Object> get props => [position];
}

// --- Eventos de Configuración de Audio ---

class ChangeVolumeEvent extends PlayerEvents {
  final double volume;

  const ChangeVolumeEvent({required this.volume});

  @override
  List<Object> get props => [volume];
}

class AddInternetTrackEvent extends PlayerEvents {
  final AudioTrack track;
  const AddInternetTrackEvent({required this.track});

  @override
  List<Object> get props => [track];
}

class ChangePitchEvent extends PlayerEvents {
  final double pitch;

  const ChangePitchEvent({required this.pitch});

  @override
  List<Object> get props => [pitch];
}
class UpdatePositionEvent extends PlayerEvents {
  final Duration position;

  const UpdatePositionEvent({required this.position});

  @override
  List<Object> get props => [position];
}

class UpdateDurationEvent extends PlayerEvents {
  final Duration duration;

  const UpdateDurationEvent({required this.duration});

  @override
  List<Object> get props => [duration];
}

class InitializePlayerEvent extends PlayerEvents {
}