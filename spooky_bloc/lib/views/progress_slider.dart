import 'package:flutter/material.dart';

class ProgressSlider extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) seek;
  final Color color;

  const ProgressSlider({
    Key? key,
    required this.position,
    required this.duration,
    required this.seek,
    required this.color,
  }) : super(key: key);

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final double durationSeconds = widget.duration.inSeconds.toDouble();
    final double positionSeconds = widget.position.inSeconds.toDouble();

    final double max = durationSeconds > 0 ? durationSeconds : 1.0;
    double value = _isDragging ? _dragValue : positionSeconds;

    value = value.clamp(0.0, max);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          activeTrackColor: widget.color,
          inactiveTrackColor: widget.color.withOpacity(0.3),
          thumbColor: widget.color,
          overlayColor: widget.color.withOpacity(0.2),
        ),
        child: Slider(
          min: 0.0,
          max: max,
          value: value,
          onChangeStart: (val) {
            setState(() {
              _isDragging = true;
              _dragValue = val;
            });
          },
          onChanged: (val) {
            setState(() {
              _dragValue = val;
            });
          },
          onChangeEnd: (val) {
            widget.seek(Duration(seconds: val.toInt()));
            setState(() {
              _isDragging = false;
            });
          },
        ),
      ),
    );
  }
}