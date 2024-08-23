import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../utils/user_session.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkLoginState(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(); // This container won't be shown; navigation happens after Future completes
          }
        },
      ),
    );
  }

  Future<void> _checkLoginState(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final username = prefs.getString('username');

    if (userId != null && username != null) {
      // User is logged in
      context.read<AuthBloc>().emit(AuthAuthenticated(userId: userId, username: username));
      UserSession.setUserId(int.parse(userId.toString()));
      BlocProvider.of<CartBloc>(context).add(LoadCart(int.parse(userId.toString())));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not logged in
      context.read<AuthBloc>().emit(AuthUnauthenticated());
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}