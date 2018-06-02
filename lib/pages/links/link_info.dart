import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

@JsonSerializable()
class LinkInfo extends Object with _$LinkInfoSerializerMixin {
  LinkInfo(this.mId, this.mName, this.mUrl);

  int mId;
  String mName;
  String mUrl;

  void log() {
    print("LinkInfo:mId=$mId,mName=$mName,mUrl=$mUrl");
  }

  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);
}
