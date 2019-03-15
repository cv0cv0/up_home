import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'page/home_page.dart';
import 'page/login_page.dart';
import 'style/themes.dart';
import 'util/const.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget _page = SizedBox();

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'zh_CN';
    _getPage();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '上家',
        theme: kTheme,
        home: _page,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CN'),
        ],
      );

  void _getPage() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool(is_login) ?? false;
    setState(() {
      _page = isLogin ? HomePage() : LoginPage();
    });
  }
}
