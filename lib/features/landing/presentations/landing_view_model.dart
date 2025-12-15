import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LandingViewModel extends BaseViewModel {
  final Map<int, Widget> createdPages = {};
  final BehaviorSubject<int> selectedIndex = BehaviorSubject.seeded(0);

  void onInit() {}

  Widget getPageAt(List<Widget> pages, int index) {
    return createdPages.putIfAbsent(index, () {
      if (index >= 0 && index < pages.length) {
        return pages[index];
      } else {
        return Container();
      }
    });
  }

  void onTabChanged(int index) {
    selectedIndex.add(index);
  }
}
