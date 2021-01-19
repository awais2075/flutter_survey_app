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
                return ListTile(
                  leading: (_surveys[index].location.isEmpty)? Icon(Icons.photo):Image.file(File(_surveys[index].location)),
                  title: Text(_surveys[index].name),
                  subtitle: Text(_surveys[index].email),
                  trailing: _deleteSurveyWidget(_surveys[index], index),
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
}
