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
  //metodo começa sempre que inicia o state do app
  @override
  void initState() {
    super.initState(); //inicia a funcao
    //funcao faz a leitura dos dados uso do then é feito para chamar outra função
    _readData().then((data) {
      setState(() {
        _listTodo = json.decode(data);
      });
    });
  }

  final _listTodoControler = TextEditingController();

  Map<String, dynamic> _lastremove;
  int _lastremovePos;

  List _listTodo = [];

  void addToDo() {
    setState(() {
      //muda/actualiza a interface.

      //para trabalhar com json usar dynamic no mapa
      Map<String, dynamic> newTodo = Map();
      //pega o texto e joga no titulo do mapa
      newTodo["title"] = _listTodoControler.text;
      _listTodoControler.text = "";
      newTodo["ok"] = false;
      _listTodo.add(newTodo);
      _saveData();
    });
  }

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
                    controller: _listTodoControler,
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
                  onPressed: addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 9.0),
              itemCount: _listTodo.length,
              //constroi o item da Listview
              itemBuilder: itemBuilder,
            ),
          ))
        ],
      ),
    );

    //layout base separado
    return Layout.getContent(context, content);
  }

  Widget itemBuilder(context, index) {
    return Dismissible(
      //uso da chave para pode indentificar a coluna que vai ser deletada
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(0.3, 0.6),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_listTodo[index]["title"]),
        value: _listTodo[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_listTodo[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _listTodo[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastremove = Map.from(_listTodo[index]);
          _lastremovePos = index;
          //remove na posicao
          _listTodo.removeAt(index);
          _saveData();
        });

        final SnackBar snackBar = SnackBar(
          content: Text("Tarefa \"${_lastremove["title"]}\"removida"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _listTodo.insert(_lastremovePos, _lastremove);
                  _saveData();
                });
              }),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
  }

  /*
     */

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

  Future<void> _refresh() async {

    await Future.delayed(Duration(seconds: 1));

    setState(() {

      _listTodo.sort((a,b){
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"]&& b["ok"]) return -1;
        else return 0;
      });

      _saveData();
    });




    return null;

  }
}
