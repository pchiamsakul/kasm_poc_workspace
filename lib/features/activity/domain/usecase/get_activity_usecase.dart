import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/helper/usecase_result.dart';
import 'package:kasm_poc_workspace/features/activity/domain/model/activity_entity.dart';

@injectable
class GetActivityUsecase {

  Future<UseCaseResult<ActivityEntity>> execute() async {
    try {
      // call api
      final response = ActivityEntity();
      return ResultSuccess(response);
    } catch (e) {
      return ResultError(e);
    }
  }
}
