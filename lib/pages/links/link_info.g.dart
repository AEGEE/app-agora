// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_info.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

LinkInfo _$LinkInfoFromJson(Map<String, dynamic> json) => new LinkInfo(
    json['mId'] as int, json['mName'] as String, json['mUrl'] as String);

abstract class _$LinkInfoSerializerMixin {
  int get mId;
  String get mName;
  String get mUrl;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'mId': mId, 'mName': mName, 'mUrl': mUrl};
}
