import 'package:flutter/material.dart';
import 'package:projeto/database/livro_dao.dart';
import '../../model/livro.dart';
import 'form.dart';
import 'package:projeto/components/alertDialog.dart';

class ListaLivro extends StatefulWidget {
  final List<Livro> _livros = [];

  @override
  State<StatefulWidget> createState() {
    return ListaLivrosState();
  }
}

class ListaLivrosState extends State<ListaLivro> {
  final LivrosDao _dao = LivrosDao();

  @override
  Widget build(BuildContext context) {
    // widget._tarefas.add(Tarefa("elaborar prova prog2", "provas diferentes"));
    // widget._tarefas.add(Tarefa("preparar aula TDM", "postar no clasroom"));

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Livros"),
      ),
      body: FutureBuilder<List<Livro>>(
        initialData: [],
        future: Future.delayed(Duration(seconds: 1))
            .then((value) => _dao.findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Livro>? livros = snapshot.data;
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final Livro livro = livros![index];
                      return ItemLivro(context, livro);
                    },
                    itemCount: livros!.length);
              }
              break;
            default:
              return Center(
                child: Text("Carregando"),
              );
          }
          return Center(
            child: Text("Carregando..."),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou botão");
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormLivro();
          }));
          future.then((livro) {
            print("Livro retornada: ");
            print(livro);
            widget._livros.add(livro);
            setState(() {});
          });
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget ItemLivro(BuildContext context, Livro _livro) {
    return GestureDetector(
      onTap: (){
          final Future future = Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return FormLivro(livro : _livro);
              }));
          future.then((value) => setState((){}));
      },
      child:  Card(
          child: ListTile(
            leading: Icon(Icons.book),
            title: Text(_livro.titulo),
            subtitle: Text(_livro.autor),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    showAlertDialog(context, "Excluir Item","Deseja mesmo excluir este item?",
                            () => _excluir(context, _livro.id)
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.remove_circle, color: Colors.red),
                  ),
                )
              ],
            ),
          ))
    );
  }
  void _excluir(BuildContext context, int id) {
    _dao.delete(id).then((value) => setState((){}));
  }
}
