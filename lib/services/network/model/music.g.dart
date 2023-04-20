// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Music _$MusicFromJson(Map<String, dynamic> json) => Music(
      id: json['id'] as int,
      cover: json['cover'] as String,
      artist: json['artist'] as String,
      lyrics: json['lyrics'] as String?,
      title: json['title'] as String,
      description: json['music_description'] as String,
      audio: json['audio'] as String,
    );

Map<String, dynamic> _$MusicToJson(Music instance) => <String, dynamic>{
      'id': instance.id,
      'music_description': instance.description,
      'title': instance.title,
      'cover': instance.cover,
      'artist': instance.artist,
      'audio': instance.audio,
      'lyrics': instance.lyrics,
    };
