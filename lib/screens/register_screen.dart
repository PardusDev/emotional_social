import 'package:emotional_social/screens/home_screen.dart';
import 'package:emotional_social/widgets/ContinueButton.dart';
import 'package:emotional_social/widgets/UserInputField.dart';
import 'package:emotional_social/widgets/right_transition.dart';
import 'package:emotional_social/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/User.dart';
import '../theme/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.registerBackgroundColor,
      body: NameSurnamePage(),
    );
  }
}

class NameSurnamePage extends StatefulWidget {
  const NameSurnamePage({super.key});

  @override
  State<NameSurnamePage> createState() => _NameSurnamePageState();
}

class _NameSurnamePageState extends State<NameSurnamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  final TextStyle textStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: AppColors.registerHeaderTextColor
  );

  bool _isOK() {
    if (_nameController.text.isEmpty || _surnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('Name and surname should not be left blank.'));
      return false;
    }
    if (_nameController.text.length >= 30 || _surnameController.text.length >= 30) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('Name and surname cannot be longer than 30 characters.'));
      return false;
    }
    _nameController.text = _nameController.text.trim();
    _surnameController.text = _surnameController.text.trim();
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.registerBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Hello! Let's get to know\neach other.",
                  style: textStyle,
                  ),
                  const WidgetSpan(child: SizedBox(width: 10,)),
                  WidgetSpan(child: Image.asset("assets/images/emojis/cute_smile.png",
                  height: (textStyle.fontSize! * textStyle.height!),))
                ]
              )
            ),
            const SizedBox(height: 35,),
            UserInputField(
                hintText: "Fist Name",
                controller: _nameController
            ),
            const SizedBox(height: 10,),
            UserInputField(
                hintText: "Last Name",
                controller: _surnameController
            ),
            const SizedBox(height: 25,),
            Align(
              alignment: Alignment.centerRight,
              child: ContinueButton(
                onPressed: () {
                  if(_isOK()) {
                    User tempUser = User(
                      name: _nameController.text,
                      surname: _surnameController.text,
                        uid: '',
                      email: '',
                    );
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondayAnimation) =>
                          EMailScreen(tempUser: tempUser), transitionsBuilder: rightTransition
                      )
                    );
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }
}

class EMailScreen extends StatefulWidget {
  final User tempUser;
  const EMailScreen({super.key, required this.tempUser});

  @override
  State<EMailScreen> createState() => _EMailScreenState();
}

class _EMailScreenState extends State<EMailScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final User tempUser;

  final TextStyle textStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      height: 1.2,
      color: AppColors.registerHeaderTextColor
  );

  @override
  void initState() {
    super.initState();
    tempUser = widget.tempUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.registerBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: "Can you share your\nemail with us?",
                          style: textStyle,
                        ),
                        const WidgetSpan(child: SizedBox(width: 10,)),
                        WidgetSpan(child: Image.asset("assets/images/emojis/pensive.png",
                          height: (textStyle.fontSize! * textStyle.height!),))
                      ]
                  )
              ),
              const SizedBox(height: 35,),
              UserInputField(
                  hintText: "E-Mail",
                  controller: _emailController
              ),
              const SizedBox(height: 25,),
              Align(
                alignment: Alignment.centerRight,
                child: ContinueButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@') ||
                        !_emailController.text.contains('.')) {
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('The email address is not in the correct format.'));
                      return;
                    }
                    if (_emailController.text.length >= 52) {
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("The email address cannot exceed 52 characters."));
                      return;
                    }
                    _emailController.text = _emailController.text.trim();
                    widget.tempUser.email = _emailController.text;
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation, secondayAnimation) =>
                                PasswordScreen(tempUser: widget.tempUser), transitionsBuilder: rightTransition
                        )
                    );
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}

class PasswordScreen extends StatefulWidget {
  final User tempUser;
  const PasswordScreen({super.key, required this.tempUser});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  late final User tempUser;

  final TextStyle textStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      height: 1.2,
      color: AppColors.registerHeaderTextColor
  );

  @override
  void initState() {
    super.initState();
    tempUser = widget.tempUser;
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Remove all other screens.
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(state.message));
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.registerBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        children: [
                            TextSpan(text: "To keep your account secure,\nplease enter your password.",
                              style: textStyle,
                            ),
                            const WidgetSpan(child: SizedBox(width: 10,)),
                            WidgetSpan(child: Image.asset("assets/images/emojis/keylock.png",
                              height: (textStyle.fontSize! * textStyle.height!),
                            )
                          )
                        ]
                    )
                ),
                const SizedBox(height: 35,),
                UserInputField(
                    hintText: "Password",
                    controller: _passwordController,
                    obscureText: true,
                ),
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.centerRight,
                  child: ContinueButton(
                    onPressed: () {
                      if (_passwordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("The password must be at least 8 characters long."));
                        return;
                      }
                      if (_passwordController.text.length > 32) {
                        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("The password cannot exceed 32 characters."));
                        return;
                      }
                      _passwordController.text = _passwordController.text.trim();
                      final email = tempUser.email;
                      final password = _passwordController.text;
                      final name = tempUser.name;
                      final surname = tempUser.surname;
                      context.read<AuthBloc>().add(SignUpRequested(email, password, name, surname));
                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}


