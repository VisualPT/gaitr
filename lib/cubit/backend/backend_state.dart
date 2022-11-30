part of 'backend_cubit.dart';

abstract class BackendState extends Equatable {
  const BackendState();

  @override
  List<Object> get props => [];
}

class BackendConnected extends BackendState {
  const BackendConnected();
}

class BackendLoading extends BackendState {
  const BackendLoading();
}

class BackendError extends BackendState {
  final String message;
  const BackendError(this.message);

  @override
  List<Object> get props => [message];
}
