// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcastEpisode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCastEpisode _$PodCastEpisodeFromJson(Map<String, dynamic> json) =>
    PodCastEpisode(
      id: json['id'] as int,
      title: json['title'] as String,
      duration: json['duration'] as String,
      audio: json['audio'] as String,
    );

Map<String, dynamic> _$PodCastEpisodeToJson(PodCastEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'audio': instance.audio,
    };
