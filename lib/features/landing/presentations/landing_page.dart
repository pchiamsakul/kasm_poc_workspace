import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/gen/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

@Named(RouterName.MainPage)
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
  int _counter = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(t.app_name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
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
