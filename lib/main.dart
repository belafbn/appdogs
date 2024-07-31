import 'package:flutter/material.dart';
import 'package:projeto/menu.dart';
import 'database/tarefa_dao.dart';

void main() {
  runApp(TarefaApp());
  //TarefaDao db = TarefaDao();
  //db.save(Tarefa(0,"tarefa teste", 'obs teste' )).then((id) {
  //  print("id gerado: "+ id.toString());
  //});
  //db.findAll().then((tarefa) => print(tarefa.toString()));
}

class TarefaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuOptions(),
      //darkTheme: ThemeData.dark(),
      theme: ThemeData(
          //scaffoldBackgroundColor: Color.fromARGB(255, 70, 70, 70),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueAccent,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.purple[900],
            elevation: 1,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.purple[900],

          ),
          listTileTheme: ListTileThemeData(
              tileColor: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.purple[900],
            splashColor: Colors.purple[200],
            foregroundColor: Colors.black54,
          )
      ),
    );
  }
}


