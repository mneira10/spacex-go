import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors.dart';

enum Themes { light, dark, black }

/// APP MODEL
/// Specific general settings about the app.
class AppModel extends Model {
  FlutterLocalNotificationsPlugin notifications;

  static String font = DateTime.now().month == 4 && DateTime.now().day == 1
      ? 'ComicSans'
      : 'ProductSans';
  static final List<ThemeData> _themes = [
    ThemeData(
      brightness: Brightness.light,
      fontFamily: font,
      primaryColor: lightPrimaryColor,
      accentColor: lightAccentColor,
      dividerColor: lightDividerColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      fontFamily: font,
      primaryColor: darkPrimaryColor,
      accentColor: darkAccentColor,
      canvasColor: darkBackgroundColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      dividerColor: darkDividerColor,
      dialogBackgroundColor: darkCardColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      fontFamily: font,
      primaryColor: blackPrimaryColor,
      accentColor: blackAccentColor,
      canvasColor: blackBackgroundColor,
      scaffoldBackgroundColor: blackBackgroundColor,
      cardColor: blackCardColor,
      dividerColor: blackDividerColor,
      dialogBackgroundColor: blackCardColor,
    )
  ];

  Themes _theme = Themes.dark;

  ThemeData _themeData = _themes[1];

  get theme => _theme;

  set theme(Themes newTheme) {
    if (newTheme != null) {
      _theme = newTheme;
      themeData = newTheme;
      notifyListeners();
    }
  }

  get themeData => _themeData;

  set themeData(Themes newTheme) {
    _themeData = _themes[newTheme.index];
    notifyListeners();
  }

  Future init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Loads the theme
    try {
      theme = Themes.values[prefs.getInt('theme')];
    } catch (e) {
      prefs.setInt('theme', 1);
    }

    // Inits notifications system
    notifications = FlutterLocalNotificationsPlugin();
    notifications.initialize(
      InitializationSettings(
        AndroidInitializationSettings('action_vehicle'),
        IOSInitializationSettings(),
      ),
    );

    await notifications.show(
      0,
      'Don\'t miss the next SpaceX launch!',
      'Falcon Heavy is launching ArabSat 6A to GTO orbit in 30 minutes.',
      NotificationDetails(
        AndroidNotificationDetails(
          'com.chechu.cherry',
          'Launch notifications',
          'Stay up-to-date with upcoming SpaceX launches',
        ),
        IOSNotificationDetails(),
      ),
    );

    notifyListeners();
  }
}