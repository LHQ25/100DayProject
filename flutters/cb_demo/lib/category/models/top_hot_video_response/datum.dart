import 'package:json_annotation/json_annotation.dart';

import 'goods_info.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  int? videoId;
  int? userId;
  int? courseId;
  String? videoTitle;
  String? videoKey;
  String? bucket;
  String? coordinate;
  String? address;
  int? cityCode;
  int? privacyType;
  String? widtheight;
  int? isDownload;
  String? resources;
  String? cover;
  String? coverMiniUrl;
  int? state;
  int? isDel;
  int? auditState;
  int? collectionId;
  String? releaseTime;
  String? createdAt;
  int? weight;
  String? head;
  String? account;
  String? nickname;
  int? mark;
  List<dynamic>? identity;
  bool? isFocus;
  bool? isPraised;
  String? courseLabel;
  String? traceId;
  String? traceInfo;
  String? collectionTitle;
  int? orderType;
  int? intMerchantId;
  int? intMerchantUserId;
  GoodsInfo? goodsInfo;
  String? url;
  int? commentCount;
  bool? isFirstComment;
  int? praisedCount;
  int? playCount;
  int? shareCount;
  int? videoTime;
  int? hot;
  int? liveId;
  String? liveNo;
  int? type;
  bool? isOnlineLive;

  Datum({
    this.videoId,
    this.userId,
    this.courseId,
    this.videoTitle,
    this.videoKey,
    this.bucket,
    this.coordinate,
    this.address,
    this.cityCode,
    this.privacyType,
    this.widtheight,
    this.isDownload,
    this.resources,
    this.cover,
    this.coverMiniUrl,
    this.state,
    this.isDel,
    this.auditState,
    this.collectionId,
    this.releaseTime,
    this.createdAt,
    this.weight,
    this.head,
    this.account,
    this.nickname,
    this.mark,
    this.identity,
    this.isFocus,
    this.isPraised,
    this.courseLabel,
    this.traceId,
    this.traceInfo,
    this.collectionTitle,
    this.orderType,
    this.intMerchantId,
    this.intMerchantUserId,
    this.goodsInfo,
    this.url,
    this.commentCount,
    this.isFirstComment,
    this.praisedCount,
    this.playCount,
    this.shareCount,
    this.videoTime,
    this.hot,
    this.liveId,
    this.liveNo,
    this.type,
    this.isOnlineLive,
  });

  @override
  String toString() {
    return 'Datum(videoId: $videoId, userId: $userId, courseId: $courseId, videoTitle: $videoTitle, videoKey: $videoKey, bucket: $bucket, coordinate: $coordinate, address: $address, cityCode: $cityCode, privacyType: $privacyType, widtheight: $widtheight, isDownload: $isDownload, resources: $resources, cover: $cover, coverMiniUrl: $coverMiniUrl, state: $state, isDel: $isDel, auditState: $auditState, collectionId: $collectionId, releaseTime: $releaseTime, createdAt: $createdAt, weight: $weight, head: $head, account: $account, nickname: $nickname, mark: $mark, identity: $identity, isFocus: $isFocus, isPraised: $isPraised, courseLabel: $courseLabel, traceId: $traceId, traceInfo: $traceInfo, collectionTitle: $collectionTitle, orderType: $orderType, intMerchantId: $intMerchantId, intMerchantUserId: $intMerchantUserId, goodsInfo: $goodsInfo, url: $url, commentCount: $commentCount, isFirstComment: $isFirstComment, praisedCount: $praisedCount, playCount: $playCount, shareCount: $shareCount, videoTime: $videoTime, hot: $hot, liveId: $liveId, liveNo: $liveNo, type: $type, isOnlineLive: $isOnlineLive)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
