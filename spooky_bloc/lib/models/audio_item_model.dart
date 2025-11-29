import 'package:equatable/equatable.dart';

class AudioItemModel extends Equatable{
  final int? id;
  final String assetPath, title, artist, imagePath;

  const AudioItemModel({
    this.id,
    required this.assetPath,
    required this.title,
    required this.artist,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, assetPath, title, artist, imagePath];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'asset_path': assetPath,
      'title': title,
      'artist': artist,
      'image_path': imagePath,
    };
  }

  factory AudioItemModel.fromMap(Map<String, dynamic> map) {
    return AudioItemModel(
      id: map['id'],
      assetPath: map['asset_path'],
      title: map['title'],
      artist: map['artist'],
      imagePath: map['image_path'],
    );
  }

  AudioItemModel copyWith(
      final int? id,
      final String? assetPath,
      final String? title,
      final String? artist,
      final String? imagePath,
  ){
    return AudioItemModel(
      id: id ?? this.id,
      assetPath: assetPath ?? this.assetPath,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'audioItemModel{id: $id, assetPath: $assetPath, title: $title, artist: $artist, imagePath: $imagePath}';
  }
}