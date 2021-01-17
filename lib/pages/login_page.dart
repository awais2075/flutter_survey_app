import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  final String _userName = "User123";
  final String _password = "1234";

  final _focus  = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headingWidget(),
                _spacingWidget(vertical: 40),
                Form(
                    key: _formKey,
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
      controller: _userNameController,
      validator: (String userName) => _validateUserName(userName),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(hintText: 'Enter Username'),
    );
  }

  TextFormField _userPasswordWidget() {
    return TextFormField(
      controller: _userPasswordController,
      validator: (String userPassword) => _validateUserPassword(userPassword),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(hintText: 'Enter Password'),
    );
  }

  ElevatedButton _loginWidget() {
    return ElevatedButton(onPressed: () => _login(), child: Text('Login'));
  }

  _spacingWidget({double horizontal, double vertical}) {
    return SizedBox(width: horizontal, height: vertical);
  }

  void _login() {
    if (_isValidInput()) {
      print('valid input');
      if (_isValidUser(
          _userNameController.text, _userPasswordController.text)) {
        print('valid user');
      } else {
        print('invalid user');
        _showSnackBar('invalid user');
      }
    } else {
      print('invalid input');
    }
  }

  String _validateUserPassword(String userPassword) {
    return userPassword.isEmpty ? 'Enter Password' : null;
  }

  String _validateUserName(String userName) {
    return userName.isEmpty ? 'Enter Password' : null;
  }

  bool _isValidInput() {
    return _formKey.currentState.validate();
  }

  bool _isValidUser(String userName, String password) {
    return (_userName == userName && _password == password);
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
