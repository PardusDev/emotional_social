part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String surname;

  const SignUpRequested(this.email, this.password, this.name, this.surname);
}

class SignOutRequested extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}