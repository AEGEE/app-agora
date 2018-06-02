import 'package:json_annotation/json_annotation.dart';

part 'news_info.g.dart';

@JsonSerializable()
class NewsInfo extends Object with _$NewsInfoSerializerMixin {
  NewsInfo(this.mId, this.mTitle, this.mBody);

  int mId;
  String mTitle;
  String mBody;

  void log() {
    print("NewsInfo:mId=$mId,mTitle=$mTitle,mBody=$mBody");
  }

  factory NewsInfo.fromJson(Map<String, dynamic> json) =>
      _$NewsInfoFromJson(json);
}
