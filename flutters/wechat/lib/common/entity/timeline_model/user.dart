import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? uid;
  String? nickname;
  String? avator;

  User({this.uid, this.nickname, this.avator});

  @override
  String toString() {
    return 'User(uid: $uid, nickname: $nickname, avator: $avator)';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? uid,
    String? nickname,
    String? avator,
  }) {
    return User(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      avator: avator ?? this.avator,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! User) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => uid.hashCode ^ nickname.hashCode ^ avator.hashCode;
}
