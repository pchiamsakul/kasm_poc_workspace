import 'package:rxdart/rxdart.dart';

typedef Continuation<T> = PublishSubject<ContinueSubject<T>>;

class ContinueSubject<T> {
  final PublishSubject<T> _subject = PublishSubject();

  Future<T> wait() async {
    final result = await _subject.first;
    return result;
  }

  void resume(T value) {
    _subject.add(value);
  }
}

extension FutureExtension<T> on PublishSubject<ContinueSubject<T>> {
  Future<T> wait() async {
    final continuation = ContinueSubject<T>();
    add(continuation);
    return await continuation.wait();
  }
}
