import 'package:json_annotation/json_annotation.dart';

part 'music.g.dart';

@JsonSerializable()
class Music {
  final int id;
  @JsonKey(name: 'music_description')
  final String description;
  final String title, cover, artist, audio;
  final String? lyrics;

  // final bool isFavourite;

  Music(
      {required this.id,
      required this.cover,
      required this.artist,
      this.lyrics,
      required this.title,
      required this.description,
      required this.audio});

  factory Music.fromJson(Map<String, dynamic> json) {
    return _$MusicFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}
