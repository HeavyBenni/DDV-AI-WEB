// auth.dart

import 'dart:js';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:ddv_gpt/main.dart';
import 'package:flutter/material.dart';

class Auth {
  static AadOAuth _oauth = _initOAuth();

  static AadOAuth _initOAuth() {
    final String tenant = 'TENANT_ID'; // Read from application settings
    final String clientId = 'CLIENT_ID'; // Read from application settings
    final String redirectUri = 'REDIRECT_URI'; // Read from application settings

    final Config config = Config(
      tenant: tenant,
      clientId: clientId,
      scope: 'openid profile offline_access',
      redirectUri: redirectUri,
      navigatorKey: navigatorKey,
      loader: SizedBox(),
      appBar: AppBar(
        title: Text('AAD OAuth Demo'),
      ),
      onPageFinished: (String url) {
        print('onPageFinished: $url');
      },
    );

    return AadOAuth(config);
  }

  static Future<bool> checkLoginStatus() async {
    // Check if user is logged in (You need to implement this)
    // Return true if logged in, false if not
    return false;
  }

  static Future<bool> login() async {
    try {
      final result = await _oauth.login();
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
      var accessToken = await _oauth.getAccessToken();
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
