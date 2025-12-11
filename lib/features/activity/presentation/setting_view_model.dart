import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/core/helper/usecase_result.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/activity/domain/model/activity_entity.dart';
import 'package:kasm_poc_workspace/features/activity/domain/usecase/get_activity_usecase.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class SettingViewModel extends BaseViewModel {
  final String title = "SettingTest";

  late final BehaviorSubject<String> behavior = BehaviorSubject.seeded(title);
  late final PublishSubject<String> publishStream = PublishSubject();
  // popup
  // navigation
  // show error message

  final GetActivityUsecase getActivityUsecase;

  SettingViewModel(this.getActivityUsecase) {
    publishStream.add(title + "Change");
  }

  Future<void> goToHome() async {
    final result = await getActivityUsecase.execute();

    switch (result) {
      case ResultSuccess():
        final data = result.data;
        break;
      case ResultError<ActivityEntity>():
        final error = result.error;
        break;
    }

    appNavigator.pushNamed(RouterName.HomePage);
  }

  Future<void> changeTitle() async {
    await Future.delayed(const Duration(seconds: 2));
    behavior.add("SettingTestChange");
  }
}

@injectable
class SettingViewModel2 extends BaseViewModel {
  final String title2 = "    SettingTest2222";

  void goToHome() {
    appNavigator.pushNamed(RouterName.HomePage);
  }
}
