import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ZCRMSDKService {
  static const androidPlatform = MethodChannel('zoho_crm_sdk');
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  //Native Method Calls through Platform Channel.

  //login to Zoho CRM account using the native android SDK method.
  Future<dynamic> login() async {
    var result = await androidPlatform.invokeMethod('loginToZohoCRM');
    return result;
  }

  //getter function that returns the current authentication status.
  Future<bool> get isUserSignedIn async =>
      await androidPlatform.invokeMethod('checkAuthenticationStatus');

  //returns the User's data from the ZCRM Database.
  Future<dynamic> getUserData() async {
    var userData = await androidPlatform.invokeMethod('getUserData');
    return jsonDecode(userData);
  }

  //Get list of records in the crm's contacts module.
  Future<dynamic> getListOfContacts() async {
    var contacts = await androidPlatform.invokeMethod('getListOfContacts');
    return jsonDecode(contacts);
  }

  //logout from Zoho CRM and delete all the local data stored in the secure storage.
  Future<dynamic> logout() async {
    var result = await androidPlatform.invokeMethod('logout');
    if (result) {
      secureStorage.delete(key: 'full_name');
      secureStorage.delete(key: 'email');
      secureStorage.delete(key: 'role');
      secureStorage.write(key: 'isLoggedIn', value: 'false');
    }
    return result;
  }
}
