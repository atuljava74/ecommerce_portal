import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignupRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthSignupRequested({required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];
}

class AuthLogoutRequested extends AuthEvent {}
