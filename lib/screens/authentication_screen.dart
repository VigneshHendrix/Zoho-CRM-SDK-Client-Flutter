import 'package:crm_sdk_client/components/my_text.dart';
import 'package:crm_sdk_client/constants/constants.dart';
import 'package:crm_sdk_client/screens/home_screen.dart';
import 'package:crm_sdk_client/services/secure_storage.dart';
import 'package:crm_sdk_client/services/zoho_crm_sdk_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigningIn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Signing In , Please Wait',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: secondary,
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ZCRMSDKService _sdk = ZCRMSDKService();
                      var loginResult = await _sdk.login();
                      if (loginResult == true) {
                        setState(() {
                          isSigningIn = true;
                        });
                        SecureStorageService _storage = SecureStorageService();
                        var userData = await _sdk.getUserData();
                        var result = await _storage.setLocalVariables(
                          userData['full_name'],
                          userData['email'],
                          userData['role']['name'],
                        );
                        setState(() {
                          isSigningIn = false;
                        });
                        if (result.toString().toLowerCase() == "success")
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: MyText(
                              result.toString().toLowerCase() == "success"
                                  ? 'Logged In Successfully'
                                  : result.toString(),
                              14,
                              'Medium',
                              primary,
                            ),
                            backgroundColor:
                                loginResult == true ? Colors.green : Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: MyText(
                              loginResult.errorMessage,
                              14,
                              'Medium',
                              primary,
                            ),
                            backgroundColor:
                                loginResult == true ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(120, 50)),
                      backgroundColor: MaterialStateProperty.all(btnColor),
                    ),
                    child: MyText(
                      'Sign in to Zoho CRM',
                      18,
                      'Light',
                      primary,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
    );
  }
}
