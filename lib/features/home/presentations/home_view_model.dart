import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class HomeViewModel extends BaseViewModel {
  final BehaviorSubject<bool> shouldShowWifiBadge = BehaviorSubject.seeded(true);

  void connectWifi() {

  }
}
