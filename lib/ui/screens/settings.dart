import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';

import '../../models/app_model.dart';
import '../../widgets/separator.dart';

/// SETTINGS SCREEN
/// Here lays all available options for the user to configurate.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local variables used in setting's toggles
  bool _darkTheme = false;
  bool _oledBlack = false;

  @override
  void initState() {
    // Get the app theme from the 'AppModel' model.
    Themes _theme = ScopedModel.of<AppModel>(context)?.theme ?? Themes.dark;

    // Update local variables according to the theme
    if (_theme == Themes.light)
      setState(() {
        _darkTheme = false;
        _oledBlack = false;
      });
    else if (_theme == Themes.black)
      setState(() {
        _darkTheme = true;
        _oledBlack = true;
      });
    else
      setState(() {
        _darkTheme = true;
        _oledBlack = false;
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(
          context,
          'app.menu.settings',
        )),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => ListView(
              children: <Widget>[
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.dark_theme.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.dark_theme.body',
                  )),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _darkTheme,
                    onChanged: (value) => _changeTheme(
                          model: model,
                          theme: value
                              ? _oledBlack ? Themes.black : Themes.dark
                              : Themes.light,
                        ),
                  ),
                ),
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.oled_black.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.oled_black.body',
                  )),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _oledBlack,
                    onChanged: (value) => _changeTheme(
                          model: model,
                          theme: value ? Themes.black : Themes.dark,
                        ),
                  ),
                ),
                Separator.divider(indent: 16, height: 0),
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.notifications.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.notifications.body',
                  )),
                  trailing: Icon(Icons.launch),
                  onTap: () => SystemSetting.goto(SettingTarget.NOTIFICATION),
                ),
                Separator.divider(height: 0),
              ],
            ),
      ),
    );
  }

  // Update the app's theme
  void _changeTheme({AppModel model, Themes theme}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('theme', theme.index);
    model.theme = theme;
    if (theme == Themes.dark)
      setState(() {
        _darkTheme = true;
        _oledBlack = false;
      });
    else if (theme == Themes.black)
      setState(() {
        _darkTheme = true;
        _oledBlack = true;
      });
    else
      setState(() {
        _darkTheme = false;
        _oledBlack = false;
      });
  }
}
