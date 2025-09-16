import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class TokenPairModel with _$TokenPairModel {
  const factory TokenPairModel({
    required String access,
    required String refresh,
  }) = _TokenPairModel;

  factory TokenPairModel.fromJson(Map<String, dynamic> json) =>
      _$TokenPairModelFromJson(json);
}
