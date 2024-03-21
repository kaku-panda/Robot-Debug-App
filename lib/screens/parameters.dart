////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:share/share.dart';
// import 'package:url_launcher/url_launcher.dart';

// my package
import 'package:robo_debug_app/main.dart';
import 'package:robo_debug_app/components/dialog.dart';
import 'package:robo_debug_app/components/modal_window.dart';
import 'package:robo_debug_app/components/style.dart';


class ParametersScreen extends ConsumerStatefulWidget {
  const ParametersScreen({Key? key}) : super(key: key);
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends ConsumerState<ParametersScreen> {
  Size screenSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    screenSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    Future<String> getVersionInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var text = packageInfo.version;
      return text;
    }

    return SizedBox();
  }
}