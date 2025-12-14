import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/features/account/presentation/account_page.dart';
import 'package:kasm_poc_workspace/features/activity/presentation/activity_page.dart';
import 'package:kasm_poc_workspace/features/home/presentations/home_page.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LandingViewModel extends BaseViewModel {
  late final List<Widget> pages;
  final Map<int, Widget> createdPages = {};
  final BehaviorSubject<int> selectedIndex = BehaviorSubject.seeded(0);

  void onInit() {
    pages = [
      // Replace with the actual pages
      // TODO remove this, please move to page instead of viewModel
      HomePage(),
      Text('Explore', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ActivityPage(),
      Text('Find Your Way', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      AccountPage(),
    ];
  }

  Widget getPageAt(int index) {
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
