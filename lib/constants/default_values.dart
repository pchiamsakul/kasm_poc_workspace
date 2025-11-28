class DefaultValues {
  DefaultValues._();

  static const String apiBaseUrl = 'api_base_url';
  static String dashboardKey(int index) => 'dashboard_$index';
  static String profileKey(int index) => 'profile_$index';

  static const int inputTextLimit = 255;

  static const int defaultTransitionDuration = 300;
  static const int paginationLimit = 10;
  static const int teamListPaginationLimit = 12;
}
