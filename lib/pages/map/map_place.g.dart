// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_place.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

MapPlace _$MapPlaceFromJson(Map<String, dynamic> json) => new MapPlace(
    json['mId'] as int,
    json['mAddress'] as String,
    json['mName'] as String,
    json['mCoordX'] as double,
    json['mCoordY'] as double);

abstract class _$MapPlaceSerializerMixin {
  int mId;
  String mAddress;
  String mName;
  double mCoordX;
  double mCoordY;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'mId': mId,
        'mAddress': mAddress,
        'mName': mName,
        'mCoordX': mCoordX,
        'mCoordY': mCoordY
      };
}
