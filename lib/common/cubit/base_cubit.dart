import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrx_pro/common/cubit/base_state.dart';

/// A base Cubit that simplifies state management by providing a standard
/// set of states (initial, loading, success, error).
///
/// [T] is the type of the data that will be held in the success state.
class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState.initial());

  /// Emits a loading state, then executes the provided [action].
  ///
  /// If the action is successful, it emits a success state with the data.
  /// If the action throws an exception, it emits an error state.
  Future<void> run(Future<T> Function() action) async {
    try {
      emit(const BaseState.loading());
      final data = await action();
      emit(BaseState.success(data: data));
    } catch (e) {
      emit(BaseState.error(message: e.toString()));
    }
  }
}
