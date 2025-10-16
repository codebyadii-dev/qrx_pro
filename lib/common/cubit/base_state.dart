// This is a required import for Freezed to work.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

@freezed
class BaseState<T> with _$BaseState<T> {
  /// The initial state.
  const factory BaseState.initial() = _Initial;

  /// The loading state.
  const factory BaseState.loading() = _Loading;

  /// The success state, which holds our data [T].
  const factory BaseState.success({required T data}) = _Success<T>;

  /// The error state, which holds an error message.
  const factory BaseState.error({required String message}) = _Error;
}
