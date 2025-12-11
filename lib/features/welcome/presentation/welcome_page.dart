import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/onboarding/presentation/widget/common_primary_button_widget.dart';
import 'package:kasm_poc_workspace/features/welcome/presentation/widget/common_secondary_button_widget.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

@Named(RouterName.WelcomePage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const WelcomePage();
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _appNavigator = getIt<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.logo.image(),
              // Dakoow to replace with powered_by_deloitte_logo when i find how to generate the path
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.7,
                        height: size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: Assets.images.logo.image(), // Dakoow, to replace
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'WELCOME TO THE KALLANG',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut l',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      CommonPrimaryButtonWidget(
                        text: 'I\'M NEW, SIGN ME UP',
                        onPressed: () {
                          _appNavigator.pushNamed(RouterName.SignupPage);
                        }, // Dakoow to replace
                      ),
                      const SizedBox(height: 12),
                      CommonSecondaryButtonWidget(
                        text: 'LOGIN',
                        onPressed: () {
                          _appNavigator.pushNamedAndRemoveAll(RouterName.HomePage);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          _appNavigator.pushNamedAndRemoveAll(RouterName.HomePage);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Continue as guest",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
