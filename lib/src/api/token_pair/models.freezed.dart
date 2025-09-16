// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TokenPairModel _$TokenPairModelFromJson(Map<String, dynamic> json) {
  return _TokenPairModel.fromJson(json);
}

/// @nodoc
mixin _$TokenPairModel {
  String get access => throw _privateConstructorUsedError;
  String get refresh => throw _privateConstructorUsedError;

  /// Serializes this TokenPairModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenPairModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenPairModelCopyWith<TokenPairModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenPairModelCopyWith<$Res> {
  factory $TokenPairModelCopyWith(
          TokenPairModel value, $Res Function(TokenPairModel) then) =
      _$TokenPairModelCopyWithImpl<$Res, TokenPairModel>;
  @useResult
  $Res call({String access, String refresh});
}

/// @nodoc
class _$TokenPairModelCopyWithImpl<$Res, $Val extends TokenPairModel>
    implements $TokenPairModelCopyWith<$Res> {
  _$TokenPairModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenPairModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_value.copyWith(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenPairModelImplCopyWith<$Res>
    implements $TokenPairModelCopyWith<$Res> {
  factory _$$TokenPairModelImplCopyWith(_$TokenPairModelImpl value,
          $Res Function(_$TokenPairModelImpl) then) =
      __$$TokenPairModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String access, String refresh});
}

/// @nodoc
class __$$TokenPairModelImplCopyWithImpl<$Res>
    extends _$TokenPairModelCopyWithImpl<$Res, _$TokenPairModelImpl>
    implements _$$TokenPairModelImplCopyWith<$Res> {
  __$$TokenPairModelImplCopyWithImpl(
      _$TokenPairModelImpl _value, $Res Function(_$TokenPairModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenPairModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_$TokenPairModelImpl(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenPairModelImpl implements _TokenPairModel {
  const _$TokenPairModelImpl({required this.access, required this.refresh});

  factory _$TokenPairModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenPairModelImplFromJson(json);

  @override
  final String access;
  @override
  final String refresh;

  @override
  String toString() {
    return 'TokenPairModel(access: $access, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenPairModelImpl &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access, refresh);

  /// Create a copy of TokenPairModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenPairModelImplCopyWith<_$TokenPairModelImpl> get copyWith =>
      __$$TokenPairModelImplCopyWithImpl<_$TokenPairModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenPairModelImplToJson(
      this,
    );
  }
}

abstract class _TokenPairModel implements TokenPairModel {
  const factory _TokenPairModel(
      {required final String access,
      required final String refresh}) = _$TokenPairModelImpl;

  factory _TokenPairModel.fromJson(Map<String, dynamic> json) =
      _$TokenPairModelImpl.fromJson;

  @override
  String get access;
  @override
  String get refresh;

  /// Create a copy of TokenPairModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenPairModelImplCopyWith<_$TokenPairModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
