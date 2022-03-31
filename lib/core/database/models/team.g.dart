// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      name: json['name'] as String,
      description: json['description'] as String,
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      supports: (json['supports'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ship: json['ship'] == null
          ? Ship.empty
          : Ship.fromJson(json['ship'] as Map<String, dynamic>),
      skills: json['skills'] == null
          ? Skills.empty
          : Skills.fromJson(json['skills'] as Map<String, dynamic>),
      maxed: json['maxed'] as int?,
      updated: json['updated'] as String?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'units': instance.units,
      'supports': instance.supports,
      'ship': instance.ship,
      'skills': instance.skills,
      'maxed': instance.maxed,
      'updated': instance.updated,
    };
