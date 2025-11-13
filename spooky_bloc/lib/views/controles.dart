import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spooky_bloc/blocs/player_bloc.dart';
import 'package:spooky_bloc/events/player_events.dart';
import 'package:spooky_bloc/states/player_states.dart';

import '../models/audio_item.dart';


class Controles extends StatelessWidget {
  final Color wormColor;

  const Controles({Key? key, required this.wormColor}) : super(key: key);

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  @override
  Widget build(BuildContext context) {
    // Escucharemos solo los cambios en el estado de reproducción.
    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, state) {
        // Obtenemos el BLoC para poder enviar eventos (es más eficiente que pasar el BLoC por parámetro)
        final bloc = context.read<PlayerBloc>();

        // Valores por defecto
        final isPlaying = (state is PlayingState) ? state.isPlaying : false;
        final positionMs = (state is PlayingState) ? state.position.inMilliseconds.toDouble() : 0.0;
        final durationMs = (state is PlayingState) ? state.duration.inMilliseconds.toDouble() : 1.0;
        final progressValue = (state is PlayingState) ? (positionMs /
            durationMs).clamp(0.0, 1.0) : 0.0;
        final currentPosition = (state is PlayingState) ? formatDuration(state.position) : "00:00";
        final totalDuration = (state is PlayingState) ? formatDuration(state.duration) : "00:00";

        // Aquí está el Widget completo:
        return Column(
          children: <Widget>[
            // --- 1. Indicador de Progreso ---
            LinearProgressIndicator(
              minHeight: 5,
              value: progressValue, // El valor ya viene calculado del estado BLoC
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(wormColor),
            ),

            // --- 2. Slider (Seek) y Tiempos ---
            if (state is PlayingState)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(currentPosition),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: durationMs,
                        value: positionMs.clamp(0.0, durationMs),
                        onChanged: (double value) {
                          // Opcional: Para feedback visual inmediato, 
                          // puedes emitir un estado temporal, pero por simplicidad, lo omitimos.
                        },
                        onChangeEnd: (double value) {
                          // Cuando el usuario suelta, disparamos el evento al BLoC
                          bloc.add(SeekEvent(
                            position: Duration(milliseconds: value.round()),
                          ));
                        },
                        activeColor: wormColor,
                        inactiveColor: Colors.grey.shade400,
                      ),
                    ),
                    Text(totalDuration),
                  ],
                ),
              ),

            // --- 3. Controles (Next, Play/Pause, Previous) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous, size: 48),
                  onPressed: () => bloc.add(PreviousEvent()),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 64,
                    color: wormColor,
                  ),
                  onPressed: () => bloc.add(PlayingPauseEvent()),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 48),
                  onPressed: () => bloc.add(NextEvent()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}