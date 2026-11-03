import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum Priority {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
}
