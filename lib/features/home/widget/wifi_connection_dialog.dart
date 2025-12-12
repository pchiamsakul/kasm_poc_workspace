import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';

class WifiConnectionDialog extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onOpenSettings;
  final bool isConnecting;
  final bool isSuccess;
  final bool isError;
  final String? message;

  const WifiConnectionDialog({
    super.key,
    this.onClose,
    this.onOpenSettings,
    this.isConnecting = false,
    this.isSuccess = false,
    this.isError = false,
    this.message,
  });

  static Future<void> show({
    required BuildContext context,
    bool isConnecting = false,
    bool isSuccess = false,
    bool isError = false,
    String? message,
    VoidCallback? onClose,
    VoidCallback? onOpenSettings,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: !isConnecting,
      builder: (context) =>
          WifiConnectionDialog(
            isConnecting: isConnecting,
            isSuccess: isSuccess,
            isError: isError,
            message: message,
            onClose: onClose,
            onOpenSettings: onOpenSettings,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnecting) ...[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(KColors.primary),
              ),
              SizedBox(height: 24),
              Text(
                'Connecting to WiFi...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Please wait while we connect you to Kallang Free WiFi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isSuccess) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Connected!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                message ?? 'You are now connected to Kallang Free WiFi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            if (isError) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Connection Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                message ?? 'Unable to connect to Kallang WiFi. Please try again.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOpenSettings?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Open WiFi Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose?.call();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: KColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
