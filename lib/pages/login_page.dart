import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headingWidget(),
                _spacingWidget(vertical: 40),
                Form(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _userNameWidget(),
                      _spacingWidget(vertical: 20),
                      _userPasswordWidget(),
                      _spacingWidget(vertical: 20),
                      _loginWidget()
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _headingWidget() {
    return Text(
      'User Login',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    );
  }

  TextFormField _userNameWidget() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Enter Username'),
    );
  }

  TextFormField _userPasswordWidget() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(hintText: 'Enter Password'),
    );
  }

  ElevatedButton _loginWidget() {
    return ElevatedButton(onPressed: () => _login(), child: Text('Login'));
  }


  _spacingWidget({double horizontal, double vertical}) {
    return SizedBox(width: horizontal, height: vertical);
  }

  _login() {}
}
