import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/core/widget/loading_container.dart';
import 'package:kasm_poc_workspace/core/widget/toast_utils.dart';
import 'package:kasm_poc_workspace/features/home/page/home_view_model.dart';
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
  final List<int> _carouselItems = [1, 2, 3, 4, 5];
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
  Widget build(BuildContext context) {
    return LoadingContainer(
      isLoading: viewModel.isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: carousel()),
                  SliverToBoxAdapter(
                    child: StreamBuilder(
                      stream: viewModel.showWifiBadgeMessage,
                      builder: (context, asyncSnapshot) {
                        return asyncSnapshot.data != true
                            ? Container()
                            : Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
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
                                ),
                              );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Home content sections
                          _buildContentSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Floating Action Buttons
            if (_showWifiButton)
              StreamBuilder(
                stream: viewModel.showWifiBadgeMessage,
                builder: (context, asyncSnapshot) {
                  return asyncSnapshot.data != true
                      ? Container()
                      : Positioned(
                          right: 16,
                          bottom: 20,
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
          ],
        ),
      ),
    );
  }

  Widget carousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        initialPage: 0,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: _carouselItems.map((i) {
        return Container(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[800]!, Colors.grey[700]!],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Assets.images.logo.image(height: 40)),
              SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hi Amanda!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'You have personalised suggestions for your visit.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.search, size: 24, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.notifications, size: 24, color: Colors.white),
                ],
              ),
              Expanded(
                child: Center(
                  child: Assets.images.placeholder.image(
                    width: 200,
                    height: 200,
                    color: Colors.white38,
                  ),
                ),
              ),
              Text(
                'WHAT\'S BIG AT THE KALLANG THIS WEEK',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text('See All Highlights >', style: TextStyle(fontSize: 14, color: Colors.white70)),
              SizedBox(height: 16),
              _buildCarouselIndicator(),
              SizedBox(height: 16),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _carouselItems.asMap().entries.map((entry) {
        bool isActive = _currentIndex == entry.key;
        return Container(
          width: isActive ? 32.0 : 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
          ),
        );
      }).toList(),
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
          width: 68,
          height: 68,
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

  Widget _buildContentSection() {
    return Column(
      children: [
        // Content grid similar to design
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildContentCard('TODAY\'S ENTRY INFO'),
            _buildContentCard('FAN GROUP ACCESS'),
            _buildContentCard('YOUR PERKS'),
            _buildContentCard('TO YOUR GATE'),
          ],
        ),
        SizedBox(height: 32),
        // Festival section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SEASONAL FESTIVAL',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Assets.images.placeholder.image(
                    width: 100,
                    height: 100,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(String title) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Assets.images.placeholder.image(
                  width: 40,
                  height: 40,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
