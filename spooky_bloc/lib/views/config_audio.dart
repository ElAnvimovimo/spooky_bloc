import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spooky_bloc/models/audio_track.dart';
import '../blocs/player_bloc.dart';
import '../events/player_events.dart';
import '../states/player_states.dart';

class ConfigAudio extends StatelessWidget {
  const ConfigAudio({Key? key}) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    const Color deepGreen = Color(0xFF0B2E33);
    const Color iceBlue = Color(0xFFB8E3E9);
    const Color tealSlate = Color(0xFF4F7C82);
    const Color softGrey = Color(0xFF93B1B5);
    final List<double> speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, playerState) {
        bool isPlaying = false;
        Duration duration = Duration.zero;
        Duration position = Duration.zero;
        double volume = 1.0;
        double pitch = 1.0;

        if (playerState is PlayingState) {
          isPlaying = playerState.isPlaying;
          duration = playerState.duration;
          position = playerState.position;
          volume = playerState.volume;
          pitch = playerState.pitch;
        }

        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: deepGreen,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Configuración de Audio',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "DMSerif",
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_down, color: iceBlue),
                      onPressed: () {
                        context.read<PlayerBloc>().add(
                          const ChangeVolumeEvent(volume: 0.0),
                        );
                      },
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: iceBlue,
                          inactiveTrackColor: softGrey.withOpacity(0.3),
                          thumbColor: iceBlue,
                          overlayColor: iceBlue.withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                        ),
                        child: Slider(
                          value: volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            context.read<PlayerBloc>().add(
                              ChangeVolumeEvent(volume: value),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: iceBlue),
                      onPressed: () {
                        context.read<PlayerBloc>().add(
                          const ChangeVolumeEvent(volume: 1.0),
                        );
                      },
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Volumen: ${(volume * 100).toInt()}%',
                    style: const TextStyle(
                      color: softGrey,
                      fontSize: 14,
                      fontFamily: "DMSerif",
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Velocidad de Reproducción',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "DMSerif",
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: speedOptions.map((speed) {
                    final isSelected = (pitch == speed);

                    return GestureDetector(
                      onTap: () {
                        context.read<PlayerBloc>().add(
                          ChangePitchEvent(pitch: speed),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? iceBlue : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? iceBlue : Colors.white12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(Icons.check, size: 16, color: deepGreen),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              '${speed}x',
                              style: TextStyle(
                                color: isSelected ? deepGreen : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tealSlate,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información del Audio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "DMSerif",
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _InfoItem(
                            label: 'Estado',
                            value: isPlaying ? 'Reproduciendo' : 'Pausado',
                          ),
                          _InfoItem(
                            label: 'Duración',
                            value: _formatDuration(duration),
                          ),
                          _InfoItem(
                            label: 'Posición',
                            value: _formatDuration(position),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontFamily: "DMSerif",
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "DMSerif",
          ),
        ),
      ],
    );
  }
}