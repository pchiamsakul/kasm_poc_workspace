import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

@Named(RouterName.PocWifiPage)
@Injectable(as: NavAble)
class PocWifiPageNavAble implements NavAble {
  @override
  Widget get(dynamic arguments) {
    return const PocWifiPage();
  }
}

class PocWifiPage extends StatelessWidget {
  const PocWifiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WiFiScannerPage(),
    );
  }
}

class WiFiScannerPage extends StatefulWidget {
  const WiFiScannerPage({super.key});

  @override
  State<WiFiScannerPage> createState() => _WiFiScannerPageState();
}

class _WiFiScannerPageState extends State<WiFiScannerPage> {
  List<WiFiAccessPoint> _wifiNetworks = [];
  bool _isScanning = false;
  bool _canScan = false;
  String _statusMessage = 'Press the button to scan for WiFi networks';

  // Controllers for connection input
  final TextEditingController _ssidController = TextEditingController(text: "Suraking_Guest");
  final TextEditingController _passwordController = TextEditingController();
  bool _isHiddenNetwork = false;
  bool _isConnecting = false;

  // Stream subscription for connectivity changes
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _startWiFiStateMonitoring();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    // Check if WiFi scan is supported
    final canScan = await WiFiScan.instance.canStartScan();
    setState(() {
      _canScan = canScan == CanStartScan.yes;
      if (!_canScan) {
        _statusMessage = 'WiFi scanning is not available on this device';
      }
    });

    // Request location permission (required for WiFi scanning)
    final status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() {
        _statusMessage = 'Location permission is required to scan WiFi networks';
      });
    }
  }

  Future<void> _scanWiFi() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning for WiFi networks...';
      _wifiNetworks = [];
    });

    try {
      // Check permission again
      final locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        setState(() {
          _statusMessage = 'Location permission denied';
          _isScanning = false;
        });
        return;
      }

      // Start WiFi scan
      final canScan = await WiFiScan.instance.canStartScan();
      if (canScan == CanStartScan.yes) {
        await WiFiScan.instance.startScan();

        // Wait a bit for scan to complete
        await Future.delayed(const Duration(seconds: 2));

        // Get scan results
        final results = await WiFiScan.instance.getScannedResults();

        setState(() {
          _wifiNetworks = results;
          _isScanning = false;
          _statusMessage =
              results.isEmpty
                  ? 'No WiFi networks found'
                  : 'Found ${results.length} WiFi network(s)';
        });
      } else {
        setState(() {
          _statusMessage = 'Cannot start WiFi scan: $canScan';
          _isScanning = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error scanning WiFi: $e';
        _isScanning = false;
      });
    }
  }

  Future<void> _connectToNetwork(String ssid, String password, bool isHidden) async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Connecting to $ssid...';
    });

    try {
      // Enable WiFi if not already enabled
      bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!wifiEnabled) {
        await WiFiForIoTPlugin.setEnabled(true);
        await Future.delayed(const Duration(seconds: 1));
      }

      // Connect to the WiFi network with timeout
      final connectFuture = WiFiForIoTPlugin.connect(
        ssid,
        password: password.isNotEmpty ? password : null,
        security: password.isNotEmpty ? NetworkSecurity.WPA : NetworkSecurity.NONE,
        joinOnce: true,
        withInternet: true,
        isHidden: isHidden,
      );

      // Add 30 second timeout
      bool connected = await connectFuture.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          setState(() {
            _isConnecting = false;
            _statusMessage = 'Connection timeout. Please try again.';
          });
          return false;
        },
      );

      setState(() {
        _isConnecting = false;
      });

      if (connected) {
        setState(() {
          _statusMessage = 'Successfully connected to $ssid';
        });
        // Trigger WiFi status update after successful connection
        Future.delayed(const Duration(seconds: 1), () {
          _updateWiFiStatus();
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to connect to $ssid. Check password and try again.';
        });
      }
    } on TimeoutException {
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Connection timeout after 30 seconds. Please try again.';
      });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Error connecting to network: $e';
      });
    }
  }

  Future<void> _disconnectFromNetwork() async {
    try {
      await WiFiForIoTPlugin.disconnect();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error disconnecting: $e';
      });
    }
  }

  void _showConnectDialog(WiFiAccessPoint network) {
    // Create local controllers for the dialog
    final dialogSsidController = TextEditingController(text: network.ssid);
    final dialogPasswordController = TextEditingController();
    bool dialogIsHidden = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(
                'Connect to ${network.ssid.isNotEmpty ? network.ssid : "Hidden Network"}',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: dialogSsidController,
                    decoration: const InputDecoration(
                      labelText: 'SSID',
                      prefixIcon: Icon(Icons.wifi),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dialogPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: dialogIsHidden,
                        onChanged: (value) {
                          setDialogState(() {
                            dialogIsHidden = value ?? false;
                          });
                        },
                      ),
                      const Text('Hidden network'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _connectToNetwork(
                      dialogSsidController.text,
                      dialogPasswordController.text,
                      dialogIsHidden,
                    );
                  },
                  child: const Text('Connect'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dispose controllers after dialog closes
      dialogSsidController.dispose();
      dialogPasswordController.dispose();
    });
  }

  void _fillInputFromNetwork(WiFiAccessPoint network) {
    setState(() {
      _ssidController.text = network.ssid.isNotEmpty ? network.ssid : '';
      _passwordController.clear();
      _isHiddenNetwork = network.ssid.isEmpty;
    });
    // Auto-focus on password field if SSID is filled
    if (_ssidController.text.isNotEmpty) {
      // Optionally scroll to top to show the input fields
      _statusMessage = 'Enter password for ${network.ssid} and click Connect';
    }
  }

  void _showNetworkOptionsDialog(WiFiAccessPoint network) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(network.ssid.isNotEmpty ? network.ssid : '<Hidden Network>'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Signal: ${network.level} dBm'),
              Text('Frequency: ${network.frequency} MHz'),
              Text('Security: ${network.capabilities.isNotEmpty ? "Secured" : "Open"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _fillInputFromNetwork(network);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Fill Form'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showConnectDialog(network);
              },
              icon: const Icon(Icons.wifi_lock),
              label: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  IconData _getWiFiIcon(int signalLevel) {
    if (signalLevel >= -50) {
      return Icons.wifi;
    } else if (signalLevel >= -60) {
      return Icons.wifi_2_bar;
    } else if (signalLevel >= -70) {
      return Icons.wifi_1_bar;
    } else {
      return Icons.wifi_1_bar;
    }
  }

  Color _getSignalColor(int signalLevel) {
    if (signalLevel >= -50) {
      return Colors.green;
    } else if (signalLevel >= -60) {
      return Colors.orange;
    } else if (signalLevel >= -70) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  void _startWiFiStateMonitoring() {
    // Initial check
    _updateWiFiStatus();

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      // Check if connected to any WiFi
      if (results.isNotEmpty) {
        final wifiResult = results.first;
        if (wifiResult != ConnectivityResult.none) {
          // Connected to WiFi, update status
          _updateWiFiStatus();
        } else {
          // Not connected to WiFi
          setState(() {
            _statusMessage = 'Not connected to any WiFi network';
          });
        }
      }
    });
  }

  Future<void> _updateWiFiStatus() async {
    if (!mounted) return;

    try {
      // Check if WiFi is enabled
      bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!wifiEnabled) {
        if (mounted) {
          setState(() {
            _statusMessage = 'WiFi is disabled';
          });
        }
        return;
      }

      // Check if connected to a WiFi network
      final connectedSSID = await WiFiForIoTPlugin.getSSID();
      if (connectedSSID != null && connectedSSID.isNotEmpty && connectedSSID != '<unknown ssid>') {
        if (mounted) {
          setState(() {
            _statusMessage = '✓ Connected to: $connectedSSID';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _statusMessage = 'Not connected to any WiFi network';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Checking WiFi status...';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('WiFi Scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect to Network',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ssidController,
                  decoration: const InputDecoration(
                    labelText: 'WiFi Network Name (SSID)',
                    hintText: 'Enter network name or tap network below',
                    prefixIcon: Icon(Icons.wifi),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password (optional)',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isHiddenNetwork,
                      onChanged: (value) {
                        setState(() {
                          _isHiddenNetwork = value ?? false;
                        });
                      },
                    ),
                    const Text('Hidden Network'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _isConnecting || _ssidController.text.isEmpty
                                ? null
                                : () {
                                  _connectToNetwork(
                                    _ssidController.text,
                                    _passwordController.text,
                                    _isHiddenNetwork,
                                  );
                                },
                        icon:
                            _isConnecting
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                : const Icon(Icons.wifi_lock),
                        label: Text(_isConnecting ? 'Connecting...' : 'Connect'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _disconnectFromNetwork,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.wifi_off),
                        label: const Text('Disconnect'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _statusMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isScanning || !_canScan ? null : _scanWiFi,
                    icon:
                        _isScanning
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.wifi_find),
                    label: Text(_isScanning ? 'Scanning...' : 'Scan WiFi'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child:
                _wifiNetworks.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No WiFi networks to display',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _wifiNetworks.length,
                      itemBuilder: (context, index) {
                        final network = _wifiNetworks[index];
                        return ListTile(
                          leading: Icon(
                            _getWiFiIcon(network.level),
                            color: _getSignalColor(network.level),
                          ),
                          title: Text(
                            network.ssid.isNotEmpty ? network.ssid : '<Hidden Network>',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'BSSID: ${network.bssid}\n'
                            'Signal: ${network.level} dBm | ${network.frequency} MHz',
                          ),
                          trailing:
                              network.capabilities.isNotEmpty
                                  ? Icon(Icons.lock, color: Colors.orange[700], size: 20)
                                  : Icon(Icons.lock_open, color: Colors.green[700], size: 20),
                          isThreeLine: true,
                          onTap: () {
                            // Show options dialog with choice to fill form or connect directly
                            _showNetworkOptionsDialog(network);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
