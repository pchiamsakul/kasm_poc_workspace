import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';

class OpenWifiSettingSheet {
  static Future<bool?> show(BuildContext context) {
    return showCupertinoModalPopup<bool?>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Wi-Fi is turned off'),
          message: const Text('To connect, you need to turn on Wi-Fi in your settings.'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                await AppSettings.openAppSettings(type: AppSettingsType.wifi);
                Navigator.pop(context, true);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
