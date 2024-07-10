import 'package:emotional_social/widgets/ContinueButton.dart';
import 'package:emotional_social/widgets/UserInputField.dart';
import 'package:emotional_social/widgets/right_transition.dart';
import 'package:emotional_social/widgets/snackbars.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Will change
      backgroundColor: Colors.white,
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
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _surnameController = new TextEditingController();

  final TextStyle textStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.2,
    // TODO: Will change
    color: Colors.black.withOpacity(0.7)
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
      // TODO: Will change
      backgroundColor: Colors.white,
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
                  WidgetSpan(child: SizedBox(width: 10,)),
                  WidgetSpan(child: Image.asset("assets/images/emojis/cute_smile.png",
                  height: (textStyle.fontSize! * textStyle.height!),))
                ]
              )
            ),
            SizedBox(height: 35,),
            UserInputField(
                hintText: "Fist Name",
                controller: _nameController
            ),
            SizedBox(height: 10,),
            UserInputField(
                hintText: "Last Name",
                controller: _surnameController
            ),
            SizedBox(height: 25,),
            Align(
              alignment: Alignment.centerRight,
              child: ContinueButton(
                onPressed: () {
                  if(_isOK()) {
                    User tempUser = new User(
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

