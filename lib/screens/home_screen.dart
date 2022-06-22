import 'package:crm_sdk_client/components/my_text.dart';
import 'package:crm_sdk_client/constants/constants.dart';
import 'package:crm_sdk_client/screens/authentication_screen.dart';
import 'package:crm_sdk_client/screens/contacts_list_screen.dart';
import 'package:crm_sdk_client/services/zoho_crm_sdk_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? firstName;
  String? email;
  bool isSigningOut = false;

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  fetchUserDetails() async {
    var firstName = await secureStorage.read(key: 'full_name');
    var email = await secureStorage.read(key: 'email');
    setState(() {
      this.firstName = firstName;
      this.email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSigningOut
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: MyText(
                'Zoho CRM SDK Client',
                18,
                'Medium',
                primary,
              ),
              backgroundColor: btnColor,
              actions: [
                IconButton(
                  onPressed: () async {
                    ZCRMSDKService _sdk = ZCRMSDKService();
                    setState(() {
                      isSigningOut = true;
                    });
                    var result = await _sdk.logout();
                    setState(() {
                      isSigningOut = false;
                    });
                    if (result) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AuthenticationScreen(),
                        ),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: MyText(
                          result
                              ? 'Logged out Successfully'
                              : result.errorMessage,
                          14,
                          'Medium',
                          primary,
                        ),
                        backgroundColor: result ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                  ),
                )
              ],
            ),
      body: isSigningOut
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
                      'Signing Out , Please Wait',
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
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      'Hi $firstName, You\'ve successfully logged in to your Zoho CRM account ! ',
                      14,
                      'Medium',
                      secondary,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactsList(),
                              ),
                            );
                          },
                          splashColor: Colors.white,
                          radius: 300,
                          child: Container(
                            child: ListTile(
                              minVerticalPadding: 0,
                              title: Center(
                                child: MyText(
                                  'Show list of contacts',
                                  15,
                                  'Medium',
                                  primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
