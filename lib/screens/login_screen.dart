import 'package:emotional_social/screens/home_screen.dart';
import 'package:emotional_social/screens/register_screen.dart';
import 'package:emotional_social/widgets/DividerWithText.dart';
import 'package:emotional_social/widgets/UserInputField.dart';
import 'package:emotional_social/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../theme/colors.dart';
import '../widgets/RoundedButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("An error occured. Please try again."));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.loginBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  "assets/images/login_header.png",
                  width: 240,
                ),
                const SizedBox(height: 56,),
                UserInputField(
                    hintText: 'E-Mail',
                    controller: _emailController,
                    obscureText: false
                ),
                const SizedBox(height: 12,),
                UserInputField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true
                ),
                const SizedBox(height: 32,),
                RoundedButton(
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    context.read<AuthBloc>().add(SignInRequested(email, password));
                  },
                  text: 'Login',
                ),
                const SizedBox(height: 18,),
                const DividerWithText(text: "or login with",),
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(GoogleSignInRequested());
                      },
                      iconSize: 40,
                      icon: Image.asset("assets/images/brands/google.png",
                        width: 40,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(text: "Don't have an account?  ",
                                style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontWeight: FontWeight.w600
                                )
                        ),
                        WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterPage())
                                );
                              },
                              child: const Text("Register!",
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontWeight: FontWeight.w600
                              ),),
                            )
                        )
                      ]
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
