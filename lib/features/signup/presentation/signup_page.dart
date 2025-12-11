import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_page.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/core/widget/custom_textfield.dart';
import 'package:kasm_poc_workspace/features/onboarding/presentation/widget/common_primary_button_widget.dart';
import 'package:kasm_poc_workspace/features/signup/presentation/signup_view_model.dart';
import 'package:kasm_poc_workspace/features/welcome/presentation/widget/common_secondary_button_widget.dart';

@Named(RouterName.SignupPage)
@Injectable(as: NavAble)
class LandingNavigator implements NavAble {
  @override
  Widget get(argument) => const SignupPage();
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends BasePage<SignupViewModel, SignupPage> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Create an account".toUpperCase(),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            "It’s free, secure and easy. Enter your email to get started.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 36),
          CustomTextField(label: 'Email', controller: TextEditingController()),
          const SizedBox(height: 16),
          CustomTextField(label: 'Password', controller: TextEditingController()),
          const SizedBox(height: 16),
          CommonPrimaryButtonWidget(text: 'Continue'.toUpperCase(), onPressed: () {}),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'or',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 32),
          CommonSecondaryButtonWidget(text: 'Continue with Google'.toUpperCase(), onPressed: () {}),
          const SizedBox(height: 16),
          CommonSecondaryButtonWidget(
            text: 'Continue with Facebook'.toUpperCase(),
            onPressed: () {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
