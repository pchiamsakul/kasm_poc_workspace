import 'package:freezed_annotation/freezed_annotation.dart';

part 'router_action.freezed.dart';

@freezed
class RouterAction with _$RouterAction {
  RouterAction._();

  factory RouterAction.resume() = _Resume;

  factory RouterAction.next(String newRoute) = _Next;

  factory RouterAction.stop() = _Stop;
}
