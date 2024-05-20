import 'package:chatify/widgets/rounded_button.dart';
import 'package:chatify/widgets/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double height;
  late double width;
  final _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
      body: Container(
        height: height * 0.98,
        width: width * 0.97,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            SizedBox(
              height: height * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: height * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: height * 0.02,
            ),
            _registerAccount(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: height * 0.10,
      child: const Text(
        'Chatify',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: height * 0.18,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              onSaved: (text) {},
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextField(
              onSaved: (text) {},
              regEx: r".{8,}",
              hintText: "Password",
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      name: 'Login',
      height: height * 0.06,
      width: width * 0.65,
      onPressed: () {},
    );
  }

  Widget _registerAccount() {
    return GestureDetector(
      onTap: () {},
      child: const Text(
        'Don\'t have an account?',
        style: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
