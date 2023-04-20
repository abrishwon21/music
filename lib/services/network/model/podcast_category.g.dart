// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCastCategory _$PodCastCategoryFromJson(Map<String, dynamic> json) =>
    PodCastCategory(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      podcasts: (json['podcasts'] as List<dynamic>)
          .map((e) => PodCast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PodCastCategoryToJson(PodCastCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'podcasts': instance.podcasts,
    };
