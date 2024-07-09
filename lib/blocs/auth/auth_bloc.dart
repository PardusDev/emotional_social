import 'package:bloc/bloc.dart';
import 'package:emotional_social/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) : _authRepository = authRepository, super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.signInWithEmailAndPassword(
          event.email, event.password);
      if (user != null) {
        final userModel = await _authRepository.getUserByUID(user.uid);
        if(userModel != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthError('User details not found.'));
        }
      } else {
        emit(AuthError('Login failed.'));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.registerWithEmailAndPassword(event.email, event.password, event.name, event.surname);
      if (user != null) {
        final userModel = await _authRepository.getUserByUID(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthError('User details not found.'));
        }
      } else {
        emit(AuthError('Login failed'));
      }
    });

    on<SignOutRequested>((event, emit) async {
      await _authRepository.signOut();
      emit(AuthInitial());
    });
  }
}