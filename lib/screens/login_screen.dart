import 'package:emotional_social/widgets/OneLineTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          print("logged");
        } else if (state is AuthError) {
          print("An error");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              OneLineTextField(hintText: 'E-Mail', controller: _emailController, obscureText: false),
              OneLineTextField(hintText: 'Password', controller: _passwordController, obscureText: false),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  context.read<AuthBloc>().add(SignInRequested(email, password));
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  final name = "nametest0";
                  final surname = "surnametest0";
                  context.read<AuthBloc>().add(SignUpRequested(email, password, name, surname));
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
