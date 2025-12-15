import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/account/presentation/account_page.dart';
import 'package:kasm_poc_workspace/features/activity/presentation/activity_page.dart';
import 'package:kasm_poc_workspace/features/home/presentations/home_page.dart';
import 'package:kasm_poc_workspace/features/landing/presentations/landing_view_model.dart';
import 'package:kasm_poc_workspace/generated/strings.g.dart';

@Named(RouterName.LandingPage)
@Injectable(as: NavAble)
class LandingNavigator implements NavAble {
  @override
  Widget get(argument) => const LandingPage();
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final LandingViewModel viewModel;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<LandingViewModel>();

    pages = [
      // Replace with the actual pages
      HomePage(),
      Text('Explore', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ActivityPage(),
      Text('Find Your Way', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: viewModel.selectedIndex,
        builder: (context, snapshot) {
          final selectedIndex = snapshot.data ?? 0;

          return IndexedStack(
            index: selectedIndex,
            children: List.generate(pages.length, (index) {
              if (viewModel.createdPages.containsKey(index) || index == selectedIndex) {
                return viewModel.getPageAt(pages, index);
              }

              // Return empty container for unvisited pages
              return Container();
            }),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: viewModel.selectedIndex,
        builder: (context, snapshot) {
          final selectedIndex = snapshot.data ?? 0;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black.withValues(alpha: 0.5),
                selectedFontSize: 12,
                unselectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                onTap: viewModel.onTabChanged,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.5)),
                    label: t.landing_page.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.5)),
                    label: t.landing_page.explore,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.5)),
                    label: t.landing_page.my_booking,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.5)),
                    label: t.landing_page.find_your_way,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.circle_outlined, color: Colors.black.withValues(alpha: 0.5)),
                    label: t.landing_page.account,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
