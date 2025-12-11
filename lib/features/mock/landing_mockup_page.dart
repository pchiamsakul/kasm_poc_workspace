import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/generated/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

@Named(RouterName.MainPage)
@Injectable(as: NavAble)
class LandingNavigator implements NavAble {
  @override
  Widget get(argument) => const LandingMockupPage();
}

class LandingMockupPage extends StatefulWidget {
  const LandingMockupPage({super.key});

  @override
  State<LandingMockupPage> createState() => _LandingMockupPageState();
}

class _LandingMockupPageState extends State<LandingMockupPage> {
  int _counter = 0;
  late final AppNavigator _appNavigator;

  @override
  void initState() {
    super.initState();

    _appNavigator = getIt<AppNavigator>();
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    var deviceInfo = await DeviceInfoPlugin().deviceInfo;

    debugPrint('Device Info: ${deviceInfo.data['identifierForVendor']}');
  }

  // ignore: unused_element
  void _launchUrl() async {
    const clientId = "YOUR_CLIENT_ID_HERE";
    const redirectUri = "myapp://callback"; // registered in Singpass portal
    const scopes = "openid myinfo.name myinfo.dob"; // modify as needed

    // final state = _generateRandomString();
    // final nonce = _generateRandomString();

    final encodedRedirectUri = Uri.encodeComponent(redirectUri);
    final encodedScope = Uri.encodeComponent(scopes);

    final authUrl = Uri.parse(
      "https://id.singpass.gov.sg/auth"
      "?response_type=code"
      "&client_id=$clientId"
      "&redirect_uri=$encodedRedirectUri"
      "&scope=$encodedScope",
      // "&state=$state"
      // "&nonce=$nonce",
    );

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch Singpass login URL");
    }
  }

  Widget buttonScreen(String route) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _appNavigator.pushNamed(route),
            child: Text(route.replaceAll('/', '')),
          ),
          SizedBox(height: 8),
          const Divider(height: 1, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(t.app_name),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text('Mockup Screen'),
              children: <Widget>[
                const Divider(height: 1, color: Colors.grey),
                buttonScreen(RouterName.PocWifiPage),
                buttonScreen(RouterName.HomePage),
                buttonScreen(RouterName.SignupPage),
                buttonScreen(RouterName.ActivityPage),
                buttonScreen(RouterName.OnboardingPage),
                buttonScreen(RouterName.WelcomePage),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
