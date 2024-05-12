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
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height
    );

    bool enableDarkTheme = ref.watch(settingProvider).enableDarkTheme;
    String webSocketAddress = ref.watch(settingProvider).webSocketAddress;

    Future<String> getVersionInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var text = packageInfo.version;
      return text;
    }

    return SafeArea(
        child: SettingsList(
          lightTheme: const SettingsThemeData(
            settingsListBackground: Styles.lightBgColor,
            settingsSectionBackground: Styles.lightColor,
          ),
          darkTheme: const SettingsThemeData(
            settingsListBackground: Styles.darkBgColor,
            settingsSectionBackground: Styles.darkColor,
          ),
          sections: [
            SettingsSection(
              title: Text('基本設定', style: Styles.defaultStyle15),
              tiles: [
                SettingsTile.navigation(
                  leading: Icon(
                    (enableDarkTheme) ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: Text('カラーテーマ', style: Styles.defaultStyle13),
                  value: Text(
                    (enableDarkTheme) ? "ダークテーマ" : "ライトテーマ",
                    style: Styles.defaultStyle13,
                  ),
                  onPressed: (value) {
                    setState(
                      () {
                        showCustomModalWindow(
                          context,
                          0.5,
                          buildModalWindowContainer(
                            context,
                            [
                              Text(
                                "ライトテーマ",
                                style: Styles.headlineStyle13,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "ダークテーマ",
                                style: Styles.headlineStyle13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                            0.5,
                            (BuildContext context, int index) {
                              setState(() {});
                              ref.read(settingProvider).enableDarkTheme =
                                  index == 1 ? true : false;
                              ref.read(settingProvider).storePreferences();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.connect_without_contact),
                  title: Text('Websocket IP Address', style: Styles.defaultStyle13),
                  value: Text(
                    webSocketAddress,
                    style: Styles.defaultStyle13,
                  ),
                  onPressed: (value) {
                    setState(
                      () {
                        final TextEditingController ipAddressController = TextEditingController(text: webSocketAddress);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Websocket IP Address'),
                              content: TextField(
                                controller: ipAddressController,
                                decoration: const InputDecoration(hintText: "192.168.x.x"),
                                keyboardType: const TextInputType.numberWithOptions(signed: true),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    setState(() {
                                      ref.read(settingProvider).webSocketAddress = ipAddressController.text;
                                      ref.read(settingProvider).storePreferences();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('その他', style: Styles.defaultStyle15),
              tiles: [
                SettingsTile.navigation(
                  trailing: FutureBuilder<String>(
                    future: getVersionInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data : '',
                        style: Styles.defaultStyle13,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  title: Text('バージョン情報', style: Styles.defaultStyle13),
                ),
              ],
            ),
          ],
        ), 
    );
  }
}