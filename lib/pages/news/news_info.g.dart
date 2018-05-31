// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_info.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

NewsInfo _$NewsInfoFromJson(Map<String, dynamic> json) =>
    new NewsInfo(json['mTitle'] as String, json['mBody'] as String);

abstract class _$NewsInfoSerializerMixin {
  String get mTitle;
  String get mBody;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'mTitle': mTitle, 'mBody': mBody};
}
