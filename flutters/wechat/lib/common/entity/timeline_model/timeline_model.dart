import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';
import 'video.dart';

part 'timeline_model.g.dart';

@JsonSerializable()
class TimelineModel {
  String? id;
  List<String>? images;
  Video? video;
  String? content;
  @JsonKey(name: 'post_type')
  String? postType;
  User? user;
  String? publishDate;
  String? location;

  TimelineModel({
    this.id,
    this.images,
    this.video,
    this.content,
    this.postType,
    this.user,
    this.publishDate,
    this.location,
  });

  @override
  String toString() {
    return 'TimelineModel(id: $id, images: $images, video: $video, content: $content, postType: $postType, user: $user, publishDate: $publishDate, location: $location)';
  }

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return _$TimelineModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);

  TimelineModel copyWith({
    String? id,
    List<String>? images,
    Video? video,
    String? content,
    String? postType,
    User? user,
    String? publishDate,
    String? location,
  }) {
    return TimelineModel(
      id: id ?? this.id,
      images: images ?? this.images,
      video: video ?? this.video,
      content: content ?? this.content,
      postType: postType ?? this.postType,
      user: user ?? this.user,
      publishDate: publishDate ?? this.publishDate,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! TimelineModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      images.hashCode ^
      video.hashCode ^
      content.hashCode ^
      postType.hashCode ^
      user.hashCode ^
      publishDate.hashCode ^
      location.hashCode;
}
