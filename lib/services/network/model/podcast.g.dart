// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCast _$PodCastFromJson(Map<String, dynamic> json) => PodCast(
      id: json['id'] as int,
      title: json['title'] as String,
      cover: json['cover'] as String,
      description: json['description'] as String?,
      duration: (json['duration'] as num).toDouble(),
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => PodCastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
      narrator: json['narrator'] as String,
    );

Map<String, dynamic> _$PodCastToJson(PodCast instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
      'description': instance.description,
      'episodes': instance.episodes,
      'duration': instance.duration,
      'narrator': instance.narrator,
    };
