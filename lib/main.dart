import 'dart:async';
import 'dart:convert';
import 'dart:io';

//layout
import 'layout.dart';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listTodo = [];

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //container para da espaçamento no app
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                //Expanded oculpa o maximo de espaço possivel na largura
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nova tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: () {},
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _listTodo.length,
                itemBuilder: (context, index) {

                }),
          )
        ],
      ),
    );

    //layout base separado
    return Layout.getContent(context, content);
  }

  //retorna um dado futuro
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_listTodo);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  //ler arquivos
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
