// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      url: json['url'] as String?,
      taps: json['taps'] as int? ?? 0,
      maxLevel: json['maxLevel'] as int? ?? 0,
      skills: json['skills'] as int? ?? 0,
      specialLevel: json['specialLevel'] as int? ?? 0,
      cottonCandy: json['cottonCandy'] as int? ?? 0,
      supportLevel: json['supportLevel'] as int? ?? 0,
      potentialAbility: json['potentialAbility'] as int? ?? 0,
      evolution: json['evolution'] as int? ?? 0,
      limitBreak: json['limitBreak'] as int? ?? 0,
      available: json['available'] as int? ?? 0,
      rumbleSpecial: json['rumbleSpecial'] as int? ?? 0,
      rumbleAbility: json['rumbleAbility'] as int? ?? 0,
      lastCheckedData: json['lastCheckedData'] as int? ?? 0,
      downloaded: json['downloaded'] as int? ?? 0,
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'id': instance.id,
      'url': instance.url,
      'taps': instance.taps,
      'maxLevel': instance.maxLevel,
      'skills': instance.skills,
      'specialLevel': instance.specialLevel,
      'cottonCandy': instance.cottonCandy,
      'supportLevel': instance.supportLevel,
      'potentialAbility': instance.potentialAbility,
      'evolution': instance.evolution,
      'limitBreak': instance.limitBreak,
      'available': instance.available,
      'rumbleSpecial': instance.rumbleSpecial,
      'rumbleAbility': instance.rumbleAbility,
      'lastCheckedData': instance.lastCheckedData,
      'downloaded': instance.downloaded,
    };
