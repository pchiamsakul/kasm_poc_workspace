import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/constants/router_name.dart';
import 'package:kasm_poc_workspace/di/configure_dependencies.dart';
import 'package:kasm_poc_workspace/i18n/strings.g.dart';
import 'package:kasm_poc_workspace/routers/app_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text('Mockup Screen'),
              children: <Widget>[
                const Divider(height: 1, color: Colors.grey),
                buttonScreen(RouterName.homePage),
                buttonScreen(RouterName.activityPage),
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
