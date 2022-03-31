// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skills _$SkillsFromJson(Map<String, dynamic> json) => Skills(
      team: json['team'] as String? ?? "",
      damageReduction: json['damageReduction'] as int? ?? 0,
      chargeSpecials: json['chargeSpecials'] as int? ?? 0,
      bindResistance: json['bindResistance'] as int? ?? 0,
      despairResistance: json['despairResistance'] as int? ?? 0,
      autoHeal: json['autoHeal'] as int? ?? 0,
      rcvBoost: json['rcvBoost'] as int? ?? 0,
      slotsBoost: json['slotsBoost'] as int? ?? 0,
      mapResistance: json['mapResistance'] as int? ?? 0,
      poisonResistance: json['poisonResistance'] as int? ?? 0,
      resilience: json['resilience'] as int? ?? 0,
    );

Map<String, dynamic> _$SkillsToJson(Skills instance) => <String, dynamic>{
      'team': instance.team,
      'damageReduction': instance.damageReduction,
      'chargeSpecials': instance.chargeSpecials,
      'bindResistance': instance.bindResistance,
      'despairResistance': instance.despairResistance,
      'autoHeal': instance.autoHeal,
      'rcvBoost': instance.rcvBoost,
      'slotsBoost': instance.slotsBoost,
      'mapResistance': instance.mapResistance,
      'poisonResistance': instance.poisonResistance,
      'resilience': instance.resilience,
    };
