// ignore_for_file: constant_identifier_names

class RouterName {
  RouterName._();

  static const NavPrefix = "";
  static const MainPage = "${NavPrefix}main";
  static const PocWifiPage = "${NavPrefix}poc-wifi";
  static const HomePage = "${NavPrefix}home";
  static const ActivityPage = "${NavPrefix}activity";
  static const SettingPage = "${NavPrefix}setting";
  static const OnboardingPage = "${NavPrefix}onboarding";
  static const WelcomePage = "${NavPrefix}welcome";
  static const SignupPage = "${NavPrefix}signup";

  static const NotFoundPage = "${NavPrefix}not-found";
  static const MockupPage = "${NavPrefix}mock-up";
}

class RouterPage {
  static const nonLoginList = <String>[];

  static const customerList = <String>[];
}
