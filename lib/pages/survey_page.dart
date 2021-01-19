import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey_app/drawers/main_drawer.dart';
import 'package:flutter_survey_app/helpers/database_helper.dart';
import 'package:flutter_survey_app/models/survey.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:http/http.dart' as http;

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  File _imageFile;
  final _imagePicker = ImagePicker();
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Survey'),
      ),
      drawer: MainDrawer(),
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headingWidget(),
              _spacingWidget(vertical: 20),
              _locationImageWidget(),
              _uploadImageWidget(),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _nameWidget(),
                        _spacingWidget(vertical: 20),
                        _emailWidget(),
                        _spacingWidget(vertical: 20),
                        _phoneNumberWidget(),
                        _spacingWidget(vertical: 20),
                        _addressWidget(),
                        _spacingWidget(vertical: 20),
                        _locationWidget(),
                        _spacingWidget(vertical: 20),
                        _remarksWidget(),
                        _spacingWidget(vertical: 20),
                        _saveWidget()
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Text _headingWidget() {
    return Text(
      'Survey Form',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    );
  }

  _spacingWidget({double horizontal, double vertical}) {
    return SizedBox(width: horizontal, height: vertical);
  }

  TextFormField _nameWidget() {
    return TextFormField(
      controller: _nameController,
      validator: (String name) => _validateName(name),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(hintText: 'Enter Name'),
    );
  }

  TextFormField _emailWidget() {
    return TextFormField(
      controller: _emailController,
      validator: (String email) => _validateEmail(email),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(hintText: 'Enter Email'),
    );
  }

  TextFormField _phoneNumberWidget() {
    return TextFormField(
      controller: _phoneNumberController,
      validator: (String phoneNumber) => _validatePhoneNumber(phoneNumber),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(hintText: 'Enter Phone Number'),
    );
  }

  TextFormField _addressWidget() {
    return TextFormField(
      controller: _addressController,
      validator: (String address) => _validateAddress(address),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(hintText: 'Enter Address'),
    );
  }

  TextFormField _locationWidget() {
    return TextFormField(
      controller: _locationController,
      // validator: (_) => _validateLocation(_locationController.text as Position),
      readOnly: true,
      decoration: InputDecoration(
          hintText: 'Current Location',
          suffixIcon: IconButton(
              onPressed: () => _getCurrentLocation(),
              icon: Icon(Icons.location_on))),
    );
  }

  TextFormField _remarksWidget() {
    return TextFormField(
      controller: _remarksController,
      maxLines: 3,
      validator: (String remarks) => _validateRemarks(remarks),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(hintText: 'Enter Remarks'),
    );
  }

  dynamic _locationImageWidget() {
    return (_imageFile == null)
        ? Icon(Icons.photo)
        : Image.file(
            _imageFile,
            width: 100,
            height: 100,
          );
  }

  ElevatedButton _saveWidget() {
    return ElevatedButton(onPressed: () => _save(), child: Text('Save'));
  }

  String _validateName(String name) {
    return name.isEmpty ? 'Invalid Name' : null;
  }

  String _validateEmail(String email) {
    return !EmailValidator.validate(email) ? 'Invalid Email' : null;
  }

  bool isValidEmail(String email) {
    String expressionString =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(expressionString);

    return regExp.hasMatch(email);
  }

  String _validatePhoneNumber(String phoneNumber) {
    /*String validArgument;
    PhoneNumberUtil.isValidPhoneNumber(phoneNumber: phoneNumber, isoCode: 'US')
        .then((isValid) => {
          print('valid : $isValid')
        });
    return validArgument;*/

    return phoneNumber.isEmpty ? 'Invalid Phone Number' : null;
  }

  String _validateAddress(String address) {
    return address.isEmpty ? 'Invalid Address' : null;
  }

  String _validateRemarks(String remarks) {
    return remarks.length < 100 ? 'Minimum 100 characters' : null;
  }

  void _getCurrentLocation() async {
    await Geolocator.getCurrentPosition()
        .then((Position position) => {
              setState(() {
                _locationController.text = "$position";
                _latitude = position.latitude;
                _longitude = position.longitude;
              })
            })
        .catchError((onError) => {
              setState(() {
                Position position = Position(latitude: 0, longitude: 0);
                _locationController.text = "$position";
                _latitude = position.latitude;
                _longitude = position.longitude;
              })
            });
  }

  _validateLocation(Position position) {
    return position == null ? 'Invalid Location' : null;
  }

  bool _isValidInput() {
    return _formKey.currentState.validate();
  }

  void _save() {
    if (_isValidInput()) {
      Survey survey = Survey(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          address: _addressController.text,
          location: (_imageFile == null) ? "" : _imageFile?.path,
          remarks: _remarksController.text,
          latitude: _latitude.toString(),
          longitude: _longitude.toString());

      Map<String, dynamic> row = survey.toMap();

      _insertData(row);
    }
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future _takeImageFromCamera() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ElevatedButton _uploadImageWidget() {
    return ElevatedButton(
        onPressed: () => _takeImageFromCamera(), child: Text('Upload Image'));
  }

  void _insertData(Map<String, dynamic> row) async {
    _databaseHelper
        .insert(row)
        .then((value) =>
            value != -1 ? _showSnackBar("Survey Added Successfully") : null)
        .catchError((error) => _showSnackBar(error.message));
  }

  Future<dynamic> _insertDataViaHttp(
      String url, Map<String, dynamic> data) async {
    return http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: data)
        .then((value) => {})
        .catchError((onError) => {});
  }
}
