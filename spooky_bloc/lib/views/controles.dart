import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math' as math;

class Controles extends StatelessWidget {
  final Function() play;
  final Function() next;
  final Function() previous;
  final bool playing;
  final Duration position;
  final Duration duration;
  final double progressPercent;
  final Color color;

  const Controles({
    Key? key,
    required this.play,
    required this.next,
    required this.previous,
    required this.playing,
    required this.position,
    required this.duration,
    required this.progressPercent,
    required this.color,
  }) : super(key: key);

  String formatDuration(Duration d) {
    if (d.inSeconds < 0) return "00:00";

    if (d.inHours > 0) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String hours = twoDigits(d.inHours);
      String minutes = twoDigits(d.inMinutes.remainder(60));
      String seconds = twoDigits(d.inSeconds.remainder(60));
      return "$hours:$minutes:$seconds";
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 50,
            child: Text(
              formatDuration(position),
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "DMSerif"),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double size = math.min(constraints.maxWidth, 180.0);
                final double radius = size / 2;
                final double iconSize = radius * 0.45;
                double safePercent = 0.0;

                if (duration.inMilliseconds > 1000) {
                  safePercent = position.inMilliseconds / duration.inMilliseconds;
                }

                safePercent = safePercent.clamp(0.0, 1.0);

                if (safePercent.isNaN || safePercent.isInfinite) {
                  safePercent = 0.0;
                }

                return CircularPercentIndicator(
                  radius: radius,
                  lineWidth: 4.0,
                  percent: safePercent,
                  animation: false,
                  animateFromLastPercent: false,

                  progressColor: color,
                  backgroundColor: Colors.blueGrey.withOpacity(0.3),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: previous,
                            icon: const Icon(Icons.skip_previous_rounded),
                            iconSize: iconSize,
                            color: Colors.black87,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: IconButton(
                              onPressed: play,
                              icon: playing
                                  ? const Icon(Icons.pause, color: Colors.white)
                                  : const Icon(Icons.play_arrow_rounded, color: Colors.white),
                              iconSize: iconSize * 1.2,
                            ),
                          ),
                          IconButton(
                            onPressed: next,
                            icon: const Icon(Icons.skip_next_rounded),
                            iconSize: iconSize,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(
            width: 50,
            child: Text(
              duration.inSeconds > 0 ? formatDuration(duration) : "--:--",
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "DMSerif"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}