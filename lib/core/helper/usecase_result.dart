sealed class UseCaseResult<T> {}

class ResultSuccess<T> extends UseCaseResult<T> {
  final T data;

  ResultSuccess(this.data);
}

class ResultError<T> extends UseCaseResult<T> {
  final dynamic error;

  ResultError(this.error);
}
