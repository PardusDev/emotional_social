import 'package:bloc/bloc.dart';
import 'package:emotional_social/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../models/User.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) : _authRepository = authRepository, super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          final userModel = await _authRepository.getUserByUID(user.uid);
          if(userModel != null) {
            emit(AuthAuthenticated(user: user, userModel: userModel));
          } else {
            emit(const AuthError('User details not found.'));
          }
        } else {
          emit(const AuthError('Login failed.'));
        }
      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(const AuthError('No user found for that email.'));
        } else if (e.code == 'wrong-password') {
          emit(const AuthError('Wrong password provided.'));
        } else {
          emit(AuthError(e.message ?? 'An unknown error occurred.'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }

    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.registerWithEmailAndPassword(
            event.email, event.password, event.name, event.surname);
        if (user != null) {
          final userModel = await _authRepository.getUserByUID(user.uid);
          if (userModel != null) {
            emit(AuthAuthenticated(user: user, userModel: userModel));
          } else {
            emit(const AuthError('User details not found.'));
          }
        } else {
          emit(const AuthError('Login failed'));
        }
      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          emit(const AuthError('The email is already in use.'));
        } else if (e.code == 'weak-password') {
          emit(const AuthError('The password provided is too weak.'));
        } else if (e.code == 'invalid-email') {
          emit(const AuthError('The email address is not valid.'));
        } else {
          emit(AuthError(e.message ?? 'An unknown error occurred.'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
});

    on<SignOutRequested>((event, emit) async {
      await _authRepository.signOut();
      emit(AuthInitial());
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        final userModel = await _authRepository.getUserByUID(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(user: user, userModel: userModel));
        } else {
          emit(const AuthError('User details not found.'));
        }
      } else {
        emit(const AuthError('Google sign-in failed.'));
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser != null) {
        final userModel = await _authRepository.getUserByUID(currentUser.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(user: currentUser, userModel: userModel));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    });
  }
}