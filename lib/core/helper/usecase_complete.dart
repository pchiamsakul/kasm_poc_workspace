sealed class UseCaseComplete {
  const UseCaseComplete();
}

class ResultComplete extends UseCaseComplete {
  const ResultComplete();
}

class ResultCompleteError extends UseCaseComplete {
  final dynamic error;

  const ResultCompleteError(this.error);
}
