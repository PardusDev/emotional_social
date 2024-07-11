import 'package:emotional_social/screens/home_screen.dart';
import 'package:emotional_social/screens/register_screen.dart';
import 'package:emotional_social/widgets/DividerWithText.dart';
import 'package:emotional_social/widgets/OneLineTextField.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                Spacer(),
                Image.asset(
                  "assets/images/login_header.png",
                  width: 240,
                ),
                SizedBox(height: 56,),
                UserInputField(
                    hintText: 'E-Mail',
                    controller: _emailController,
                    obscureText: false
                ),
                SizedBox(height: 12,),
                UserInputField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true
                ),
                SizedBox(height: 32,),
                RoundedButton(
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    context.read<AuthBloc>().add(SignInRequested(email, password));
                  },
                  text: 'Login',
                ),
                SizedBox(height: 18,),
                DividerWithText(text: "or login with",),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO: Google icon
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
                Spacer(),
                RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Don't have an account?  ",
                                style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontWeight: FontWeight.w600
                                )
                        ),
                        WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                print("Register text button clicked.");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterPage())
                                );
                              },
                              child: Text("Register!",
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
