package com.kasm_poc_workspace

import android.content.Context
import android.net.*
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "wifi_temporary_connection"
    private lateinit var connectivityManager: ConnectivityManager
    private var temporaryNetworkCallback: ConnectivityManager.NetworkCallback? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "connectToWifiTemporary" -> {
                    val ssid = call.argument<String>("ssid")
                    val password = call.argument<String>("password")
                    val timeoutSeconds = call.argument<Int>("timeoutSeconds") ?: 30

                    if (ssid != null) {
                        connectToWifiTemporary(ssid, password, timeoutSeconds, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "SSID is required", null)
                    }
                }

                "disconnectTemporaryNetwork" -> {
                    disconnectTemporaryNetwork(result)
                }

                "isTemporaryNetworkConnected" -> {
                    result.success(isTemporaryNetworkConnected())
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun connectToWifiTemporary(
        ssid: String,
        password: String?,
        timeoutSeconds: Int,
        result: MethodChannel.Result
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            result.error("UNSUPPORTED", "Temporary network connections require Android 10+", null)
            return
        }

        try {
            // Disconnect any existing temporary network first
            temporaryNetworkCallback?.let {
                connectivityManager.unregisterNetworkCallback(it)
            }

            val specifierBuilder = WifiNetworkSpecifier.Builder()
                .setSsid(ssid)

            if (password != null && password.isNotEmpty()) {
                specifierBuilder.setWpa2Passphrase(password)
            }

            val networkRequest = NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .setNetworkSpecifier(specifierBuilder.build())
                .build()

            val callback = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    super.onAvailable(network)
                    // Bind the process to this network for temporary use
                    connectivityManager.bindProcessToNetwork(network)
                    result.success(true)
                }

                override fun onUnavailable() {
                    super.onUnavailable()
                    result.success(false)
                }

                override fun onLost(network: Network) {
                    super.onLost(network)
                    // Network lost, unbind process
                    connectivityManager.bindProcessToNetwork(null)
                }
            }

            temporaryNetworkCallback = callback

            // Request the network with timeout
            connectivityManager.requestNetwork(networkRequest, callback, timeoutSeconds * 1000)

        } catch (e: Exception) {
            result.error("CONNECTION_ERROR", "Failed to connect: ${e.message}", null)
        }
    }

    private fun disconnectTemporaryNetwork(result: MethodChannel.Result) {
        try {
            // Unbind process from current network
            connectivityManager.bindProcessToNetwork(null)

            // Unregister the callback
            temporaryNetworkCallback?.let {
                connectivityManager.unregisterNetworkCallback(it)
                temporaryNetworkCallback = null
            }

            result.success(true)
        } catch (e: Exception) {
            result.error("DISCONNECT_ERROR", "Failed to disconnect: ${e.message}", null)
        }
    }

    private fun isTemporaryNetworkConnected(): Boolean {
        return try {
            val boundNetwork = connectivityManager.boundNetworkForProcess
            boundNetwork != null && connectivityManager.getNetworkCapabilities(boundNetwork)
                ?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
        } catch (e: Exception) {
            false
        }
    }
}
