import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
  String? cover;
  String? url;

  Video({this.cover, this.url});

  @override
  String toString() => 'Video(cover: $cover, url: $url)';

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  Video copyWith({
    String? cover,
    String? url,
  }) {
    return Video(
      cover: cover ?? this.cover,
      url: url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Video) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => cover.hashCode ^ url.hashCode;
}
