import 'package:flutter/material.dart';

class ProgressSlider extends StatelessWidget {
  final Duration position, duration;
  final Function(Duration) seek;
  final Color color;

  const ProgressSlider(
      {super.key,
        required this.position,
        required this.duration,
        required this.seek,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .75,
      //height: MediaQuery.of(context).size.height * .3,
      child: SliderTheme(
        data: SliderThemeData(
          thumbColor: color,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
          activeTickMarkColor: color,
          inactiveTickMarkColor: Color(0xffed6a5a),
          activeTrackColor: color,
          inactiveTrackColor: Color(0xffed6a5a),

        ),
        child: Slider(
          value: position.inSeconds.toDouble(),
          max: duration.inSeconds.toDouble(),
          min: 0,
          onChanged: (value) {
            seek(Duration(seconds: value.toInt()));
          },
        ),
      ),
    );
  }
}

