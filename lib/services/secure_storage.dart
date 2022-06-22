import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  //store the credentials of the user in local after successful login using the CRM SDK.
  Future<String> setLocalVariables(var fullName, var emailID, var role) async {
    final bool isValidResult = emailID != null && fullName != null;

    if (isValidResult) {
      await secureStorage.write(
        key: 'isLoggedIn',
        value: 'true',
      );
      await secureStorage.write(
        key: 'full_name',
        value: fullName,
      );
      await secureStorage.write(
        key: 'email',
        value: emailID,
      );
      await secureStorage.write(
        key: 'role',
        value: role,
      );
      return 'Success';
    } else {
      return 'Something went Wrong!';
    }
  }
}
