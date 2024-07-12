import 'package:emotional_social/repositories/auth_repository.dart';
import 'package:emotional_social/repositories/post_repository.dart';
import 'package:emotional_social/screens/home_screen.dart';
import 'package:emotional_social/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/post/post_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => PostRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(create: (context) => PostBloc(postRepository: context.read<PostRepository>()))
        ],
        child: MaterialApp(
          title: 'Emotion Social',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: true,
          ),
          home: BlocBuilder<AuthBloc, AuthState> (
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
