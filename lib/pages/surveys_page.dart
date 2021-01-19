import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_survey_app/drawers/main_drawer.dart';
import 'package:flutter_survey_app/helpers/database_helper.dart';
import 'package:flutter_survey_app/models/survey.dart';

class SurveysPage extends StatefulWidget {
  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  final List<Survey> _surveys = [];

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int _currentIndex = -1;
  @override
  void initState() {
    _getAllSurveys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveys'),
      ),
      drawer: MainDrawer(),
      body: (_surveys.isEmpty)
          ? Center(child: _noSurveyDataWidget())
          : ListView.builder(
              itemCount: _surveys.length,
              itemBuilder: (BuildContext context, int index) {
                _currentIndex = index;
                return ListTile(
                  leading: (_surveys[index].location.isEmpty)? Icon(Icons.photo):Image.file(File(_surveys[index].location)),
                  title: Text(_surveys[index].name),
                  subtitle: Text(_surveys[index].email),
                  trailing: _deleteSurveyWidget(_surveys[index], index),
                  onTap: _showSurveyDetail,
                );
              }),
    );
  }

  void _getAllSurveys() async {
    _databaseHelper.getAllRows().then((rows) => {
          for (var index = 0; index < rows.length; index++)
            {
              setState(() {
                _surveys.add(Survey.fromMap(rows[index]));
              })
            }
        });
  }

  Text _noSurveyDataWidget() {
    return Text('No Data Found');
  }

  ElevatedButton _deleteSurveyWidget(Survey survey, int index) {
    return ElevatedButton(
      onPressed: () => _deleteSurvey(survey, index),
      child: Text(
        'Delete',
      ),
      style: ElevatedButton.styleFrom(primary: Colors.red),
    );
  }

  _deleteSurvey(Survey survey, int index) {
    _databaseHelper
        .deleteById(survey.id)
        .then((int result) => {_updateSurveysList(result, index)})
        .catchError((error) => {print(error.message)});
  }

  void _updateSurveysList(int result, int index) {
    if (result == 1) {
      setState(() {
        _surveys.removeAt(index);
      });
    }
  }

  Future<void> _showSurveyDetail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  (_surveys[_currentIndex].location.isEmpty)? Icon(Icons.photo):Image.file(File(_surveys[_currentIndex].location)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name : ${_surveys[_currentIndex].name}'),
                Text('Email : ${_surveys[_currentIndex].email}'),
                Text('Address : ${_surveys[_currentIndex].address}'),
                Text('Address : ${_surveys[_currentIndex].remarks}'),
                Text('Address : ${_surveys[_currentIndex].longitude} - ${_surveys[_currentIndex].longitude}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
