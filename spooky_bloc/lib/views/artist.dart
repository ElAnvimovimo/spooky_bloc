import 'package:flutter/material.dart';

class Artist extends StatelessWidget {
  final String artist, name;

  const Artist({Key? key, required this.artist, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          name,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: "DMSerif"
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontFamily: "DMSerif"
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}