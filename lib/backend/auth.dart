// auth.dart

import 'dart:js';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:ddv_gpt/main.dart';
import 'package:flutter/material.dart';

class Auth {
  static final Config config = Config(
    tenant: 'TENANT_ID',
    clientId: 'CLIENT_ID',
    scope: 'openid profile offline_access',
    redirectUri: 'REDIRECT_URI', // Provide your redirect URI here
    navigatorKey: navigatorKey,
    loader: SizedBox(),
    appBar: AppBar(
      title: Text('AAD OAuth Demo'),
    ),
    onPageFinished: (String url) {
      print('onPageFinished: $url');
    },
  );
  static final AadOAuth oauth = AadOAuth(config);

  static Future<bool> checkLoginStatus() async {
    try {
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> login() async {
    try {
      final result = await oauth.login();
      result.fold(
        (l) {
          showError(l.toString());
          return false;
        },
        (r) {
          showMessage('Logged in successfully, your access token: $r');
          return true;
        },
      );
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        ScaffoldMessenger.of(context as BuildContext).hideCurrentSnackBar();
        ScaffoldMessenger.of(context as BuildContext)
            .showSnackBar(SnackBar(content: Text(accessToken)));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  static void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  static void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context as BuildContext);
          })
    ]);
    showDialog(
        context: context as BuildContext,
        builder: (BuildContext context) => alert);
  }
}
