import 'package:ecommerce_portal/utils/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/user_session.dart';
import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CartBloc cartBloc;

  AuthBloc({required this.cartBloc}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _loadSession(); // Load session on app start
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}login.php'),
        body: {
          'email': event.email,
          'password': event.password,
        },
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        // Save session data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', data['user_id'].toString());
        await prefs.setString('username', data['username']);
        UserSession.setUserId(int.parse(data['user_id'].toString()));
        cartBloc.add(LoadCart(UserSession.userId!));
        emit(AuthAuthenticated(userId: data['user_id'].toString(), username: data['username']));
      } else {
        emit(AuthUnauthenticated(message: data['message']));
      }
    } catch (e) {
      emit(AuthUnauthenticated(message: 'Login failed. Please try again.'));
    }
  }

  Future<void> _onSignupRequested(AuthSignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}signup.php'),
        body: {
          'username': event.username,
          'email': event.email,
          'password': event.password,
        },
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        emit(AuthUnauthenticated(message: 'Signup successful. Please log in.'));
      } else {
        emit(AuthUnauthenticated(message: data['message']));
      }
    } catch (e) {
      emit(AuthUnauthenticated(message: 'Signup failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    // Clear session data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    emit(AuthUnauthenticated());
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final username = prefs.getString('username');
    UserSession.setUserId(int.parse(userId.toString()));
    if (userId != null && username != null) {
      emit(AuthAuthenticated(userId: userId, username: username));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
