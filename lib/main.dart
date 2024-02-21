import 'package:ddv_gpt/backend/auth.dart';
import 'package:ddv_gpt/backend/chat.dart';
import 'package:ddv_gpt/frontend/home.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import Dio package
import 'dart:convert';
import 'dart:developer';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// main.dart

import 'package:flutter/material.dart';
import 'package:ddv_gpt/backend/auth.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAD OAuth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
