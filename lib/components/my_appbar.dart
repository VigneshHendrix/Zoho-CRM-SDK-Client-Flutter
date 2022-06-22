import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crm_sdk_client/components/my_text.dart';
import 'package:crm_sdk_client/constants/constants.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final Size preferredSize = Size.fromHeight(50.0);
  MyAppBar(this.title);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: secondary,
      elevation: 0,
      title: MyText(
        this.widget.title,
        20,
        'Medium',
        secondary,
      ),
    );
  }
}
