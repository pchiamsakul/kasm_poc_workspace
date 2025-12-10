import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/onboarding/data/model/onboarding_model.dart';
import 'package:kasm_poc_workspace/features/onboarding/presentation/widget/common_primary_button_widget.dart';
import 'package:kasm_poc_workspace/features/onboarding/presentation/widget/onboarding_dot_indicator_widget.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

@Named(RouterName.OnboardingPage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const OnboardingPage();
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _appNavigator = getIt<AppNavigator>();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      imagePath: "",
      title: 'ONBOARDING TITLE 1',
      subtitle:
          '1 sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
    OnboardingPageModel(
      imagePath: "",
      title: 'ONBOARDING TITLE 2',
      subtitle:
          '2 sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
    OnboardingPageModel(
      imagePath: "",
      title: 'ONBOARDING TITLE 3',
      subtitle:
          '3 sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
  ];

  void _goNext() {
    final lastIndex = _pages.length - 1;
    if (_currentPage == lastIndex) {
      _appNavigator.pushNamed(RouterName.SettingPage);
      // Navigator.of(context).pushReplacement(
      // MaterialPageRoute(builder: (_) => const GetStartedPage()),
      // );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() {
                  _currentPage = index;
                }),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: size.width * 0.8,
                          height: size.width * 1.1,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.rectangle,
                          ),
                          child: Assets.images.logo.image(), // Dakoow, to replace
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.subtitle,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  OnboardingDotIndicatorWidget(
                    total: _pages.length,
                    current: _currentPage,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  CommonPrimaryButtonWidget(
                    text: isLast ? 'GET STARTED' : 'NEXT',
                    onPressed: _goNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
