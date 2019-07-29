import 'package:flutter/material.dart';


class Layout {

  static Scaffold getContent(BuildContext context,content){


    return Scaffold(

      appBar: AppBar(
        //backgroundColor: Color.fromRGBO(255, 250, 250,1),
        backgroundColor: Colors.blueAccent,
        title: Text("Lista de tarefas"),
        centerTitle: true,

      ),
      body: content,
    );
  }

}