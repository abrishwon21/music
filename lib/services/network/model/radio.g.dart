// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioStation _$RadioStationFromJson(Map<String, dynamic> json) => RadioStation(
      id: json['id'] as int,
      stationName: json['station_name'] as String,
      mhz: json['mhz'] as String,
      url: json['url'] as String,
      coverImage: json['coverImage'] as String,
    );

Map<String, dynamic> _$RadioStationToJson(RadioStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_name': instance.stationName,
      'mhz': instance.mhz,
      'url': instance.url,
      'coverImage': instance.coverImage,
    };
