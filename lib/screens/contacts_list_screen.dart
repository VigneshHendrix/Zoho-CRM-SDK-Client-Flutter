import 'package:crm_sdk_client/components/my_appbar.dart';
import 'package:crm_sdk_client/components/my_text.dart';
import 'package:crm_sdk_client/constants/constants.dart';
import 'package:crm_sdk_client/services/zoho_crm_sdk_service.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('List of contacts'),
      body: FutureBuilder(
        future: _listOfContactsApi(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var contacts = snapshot.data["data"];
            return Padding(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 30),
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 16.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 360,
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  MyText(
                                    'First Name : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['First_Name'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Last Name : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Last_Name'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Account Name : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Account_Name']['name'] ??
                                        "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Contact Number: ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Phone'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Email address : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Email'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'D.O.B : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Date_of_Birth'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Lead Source : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Lead_Source'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Contact Owner : ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['Owner']['name'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                children: [
                                  MyText(
                                    'Record ID: ',
                                    14,
                                    'Medium',
                                    btnColor,
                                  ),
                                  MyText(
                                    contacts[index]['id'] ?? "None",
                                    14,
                                    'Light',
                                    secondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: btnColor,
              ),
            );
          }
        },
      ),
    );
  }

  _listOfContactsApi() async {
    ZCRMSDKService _sdk = ZCRMSDKService();
    return await _sdk.getListOfContacts();
  }
}
