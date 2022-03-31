// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rumble.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RumbleTeam _$RumbleTeamFromJson(Map<String, dynamic> json) => RumbleTeam(
      name: json['name'] as String,
      description: json['description'] as String,
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updated: json['updated'] as String?,
      mode: json['mode'] as int,
    );

Map<String, dynamic> _$RumbleTeamToJson(RumbleTeam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'units': instance.units,
      'updated': instance.updated,
      'mode': instance.mode,
    };
