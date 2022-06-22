import 'package:crm_sdk_client/screens/authentication_screen.dart';
import 'package:crm_sdk_client/screens/home_screen.dart';
import 'package:crm_sdk_client/services/zoho_crm_sdk_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var isLoggedIn = await secureStorage.read(key: 'isLoggedIn');
  if (isLoggedIn == 'true') {
    ZCRMSDKService _sdk = ZCRMSDKService();
    _sdk.login();
  }
  runApp(SDKClientApp(isUserLoggedIn: isLoggedIn == 'true' ? true : false));
}

class SDKClientApp extends StatefulWidget {
  SDKClientApp({this.isUserLoggedIn});
  final isUserLoggedIn;

  @override
  State<SDKClientApp> createState() => _SDKClientAppState();
}

class _SDKClientAppState extends State<SDKClientApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget.isUserLoggedIn ? HomeScreen() : AuthenticationScreen(),
    );
  }
}
