import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/const.dart';
import '../util/validates.dart';
import '../widget/password_field.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String phoneNumber;
  String password;
  String code;

  bool _autovalidate = false;
  bool _isCode = false;
  bool _codeHasSent = false;
  bool _isCancel;

  Timer timer;
  String _codeCountdown = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('上家服务'),
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 32.0),
                  child: Image.asset('asset/icon/login_logo.png'),
                ),
                TextFormField(
                  validator: validatePhoneNumber,
                  onSaved: (value) => phoneNumber = value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '手机号码',
                    hintText: '请输入手机号码',
                  ),
                ),
                _isCode
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return '请输入收到的短信验证码';
                                return null;
                              },
                              onSaved: (value) => code = value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '验证码',
                                hintText: '请输入验证码',
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 2.0),
                            child: RaisedButton(
                              onPressed: _codeHasSent ? null : _sendCode,
                              child: Text('发送验证码$_codeCountdown',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      )
                    : PasswordField(
                        validator: (value) {
                          if (value.isEmpty) return '请输入密码';
                          return null;
                        },
                        onSaved: (value) => password = value,
                        decoration: InputDecoration(
                          labelText: '密码',
                          hintText: '请输入密码',
                        ),
                      ),
                Container(
                  width: double.infinity,
                  height: 42.0,
                  margin: const EdgeInsets.only(top: 42.0, bottom: 24.0),
                  child: RaisedButton(
                    child: const Text('登录',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    onPressed: _handleSubmitted,
                  ),
                ),
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => _isCode = !_isCode),
                      child: Text(_isCode ? ' 密码登录' : ' 验证码登录'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: const Text('注册为技师 '),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    if (timer != null && timer.isActive) timer.cancel();
    super.dispose();
  }

  void _handleSubmitted() async {
    final formState = _formKey.currentState;
    if (!formState.validate()) {
      setState(() {
        _autovalidate = true;
      });
    } else {
      formState.save();
      _isCancel = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
      ).whenComplete(() {
        _isCancel = true;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(is_login, true);

      Future.delayed(Duration(seconds: 2), () {
        if (_isCancel) return;

        Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false,
            );
      });
    }
  }

  void _sendCode() {
    setState(() {
      _codeHasSent = true;
      _codeCountdown = '(60s)';
    });

    int countdown = 60;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (t) => setState(() {
            if (--countdown == 0) {
              t.cancel();
              _codeHasSent = false;
              _codeCountdown = '';
            } else {
              _codeCountdown = '(${countdown}s)';
            }
          }),
    );
  }
}
