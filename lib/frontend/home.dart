import 'dart:ui';
import 'package:ddv_gpt/backend/auth.dart';
import 'package:ddv_gpt/frontend/chat.dart';
import 'package:ddv_gpt/frontend/components/navbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoggingIn = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Auth.login(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              children: [
                // Blurred background
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        } else {
          final bool isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: CustomNavBar(),
              ),
              body: ChatScreen(),
            );
          }
          {
            return Scaffold();
          }
        }
      },
    );
  }
}
