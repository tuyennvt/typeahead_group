import 'dart:ui';

import 'package:example/map_data.dart';
import 'package:flutter/material.dart';
import 'package:typeahead_group/typeahead_group.dart';

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'typeahead_group demo',
      scrollBehavior:
          MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FormExample(),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TypeAheadGroupFormField<MapData>(
              typeAheadGroupConfiguration: TypeAheadGroupConfiguration(
                decoration: InputDecoration(labelText: 'City'),
                controller: this._typeAheadController,
              ),
              suggestionsGroupCallback: (pattern) {
                return dataGroup;
              },
              titleGroupBuilder: (context, String title) {
                return Container(
                  color: Colors.blue,
                  child: ListTile(
                    title: Text(title),
                  ),
                );
              },
              itemBuilder: (context, MapData suggestion) {
                return ListTile(
                  title: Text(suggestion.label),
                );
              },
              transitionBuilder: (context, suggestionsGroupBox, controller) {
                return suggestionsGroupBox;
              },
              onSuggestionGroupSelected: (MapData suggestion) {},
              validator: (value) => value!.isEmpty ? 'Please select a city' : null,
              onSaved: (value) => this._selectedCity = value,
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (this._formKey.currentState!.validate()) {
                  this._formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your Favorite City is ${this._selectedCity}'),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
