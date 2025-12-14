import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/core/widget/toast_utils.dart';
import 'package:kasm_poc_workspace/features/home/presentations/home_view_model.dart';
import 'package:kasm_poc_workspace/features/home/presentations/widgets/carousel.dart';
import 'package:kasm_poc_workspace/features/home/widget/open_wifi_setting_sheet.dart';
import 'package:kasm_poc_workspace/generated/assets.gen.dart';

@Named(RouterName.HomePage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const HomePage();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AppNavigatorListenState<HomePage, HomeViewModel> {
  int _currentIndex = 0;
  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      bannerImage: Assets.images.placeholder.image(height: 48, width: 48, fit: BoxFit.cover),
      bannerText: 'What’s Big at Kallang This Week',
      bannerDescription: 'See All Highlights > 0',
    ),
    CarouselItem(
      bannerImage: Assets.images.placeholder.image(height: 48, width: 48, fit: BoxFit.cover),
      bannerText: 'What’s Big at Kallang This Week',
      bannerDescription: 'See All Highlights > 1',
    ),
    CarouselItem(
      bannerImage: Assets.images.placeholder.image(height: 48, width: 48, fit: BoxFit.cover),
      bannerText: 'What’s Big at Kallang This Week',
      bannerDescription: 'See All Highlights > 2',
    ),
    CarouselItem(
      bannerImage: Assets.images.placeholder.image(height: 48, width: 48, fit: BoxFit.cover),
      bannerText: 'What’s Big at Kallang This Week',
      bannerDescription: 'See All Highlights > 3',
    ),
  ];
  bool _showWifiButton = true;

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  void onResume() {
    super.onResume();
    viewModel.resumeCheckWifi();
  }

  @override
  void initState() {
    super.initState();
    viewModel.initialize();

    viewModel.showSuccessConnectWifi.listen((wifiName) {
      ToastUtils.showSuccess(context, message: "Connected $wifiName Wi-Fi");
    });

    viewModel.showWifiTurnOffSuggestion.listen((continuation) async {
      final result = await OpenWifiSettingSheet.show(context);
      continuation.resume(result == true);
    });
  }

  @override
  bool get isShowAppBar => false;

  @override
  bool get isSafeAreaTopEnabled => false;

  Widget _buildActivityCard({Image? image, String? title, String? description}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        color: Colors.black.withValues(alpha: 0.1),
        child: Row(
          children: <Widget>[
            image ?? Assets.images.placeholder.image(height: 54, width: 54, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (title != null)
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  if (description != null) Text(description, style: TextStyle(fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      height: 170,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(image: AssetImage(Assets.images.placeholder.path)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Brewerkz Riverside',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required Widget icon,
    required VoidCallback onPressed,
    bool showCloseButton = false,
    VoidCallback? onClose,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: KColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(34),
              child: Center(child: icon),
            ),
          ),
        ),
        if (showCloseButton && onClose != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Assets.icons.xClose.svg(
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Color(0xFF4D4D4D),
                child: Column(
                  children: <Widget>[
                    Center(child: Assets.images.logo.image()),
                    SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Hi Amanda!',
                                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                                Text(
                                  'These are today’s picks for you',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.search, size: 24, color: Colors.white),
                          SizedBox(width: 16),
                          Icon(Icons.notifications, size: 24, color: Colors.white),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Carousel(
                        currentIndex: _currentIndex,
                        carouselItems: _carouselItems,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                stream: viewModel.showWifiBadgeMessage,
                builder: (context, asyncSnapshot) {
                  return asyncSnapshot.data != true
                      ? SizedBox.shrink()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(color: Colors.black),
                          child: SafeArea(
                            top: false,
                            child: Row(
                              children: [
                                Icon(Icons.wifi, color: Colors.white, size: 24),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'You\'re in a Free Wi-Fi zone. Tap the icon below to connect.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildContentSection(),
                    // Home content sections
                    SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: _buildActivityCard(title: 'Play Badminton')),
                          SizedBox(width: 8),
                          Expanded(child: _buildActivityCard(title: 'Pop Concerts')),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: _buildActivityCard(title: 'Family Time')),
                          SizedBox(width: 8),
                          Expanded(child: _buildActivityCard(title: 'Get Active')),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        // Need to update to be dynamic based on the number of events
                        children: List.generate(
                          20,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Assets.images.placeholder.image(height: 28, width: 28),
                                SizedBox(height: 16),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text('Event $index'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'winter Festival highlights'.toUpperCase(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildEventCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Floating Action Buttons
        if (_showWifiButton)
          StreamBuilder(
            stream: viewModel.showWifiBadgeMessage,
            builder: (context, snapshot) {
              return snapshot.data != true
                  ? Container()
                  : Positioned(
                      right: 16,
                      bottom: 88,
                      child: _buildFloatingButton(
                        icon: Assets.icons.wifi.svg(
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        onPressed: viewModel.connectWifi,
                        showCloseButton: true,
                        onClose: () {
                          setState(() {
                            _showWifiButton = false;
                          });
                        },
                      ),
                    );
            },
          ),
        Positioned(
          right: 16,
          bottom: 20,
          child: _buildFloatingButton(
            icon: Assets.icons.chat.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: viewModel.connectWifi,
            showCloseButton: true,
          ),
        ),
      ],
    );
  }
}
