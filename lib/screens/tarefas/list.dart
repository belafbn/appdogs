import 'package:flutter/material.dart';
import 'package:projeto/components/alertDialog.dart';
import 'package:projeto/database/tarefa_dao.dart';
import 'package:projeto/database/livro_dao.dart';
import '../../model/tarefa.dart';
import '../../model/livro.dart';
import 'form.dart';

class ListaTarefa extends StatefulWidget {
  final List<Tarefa> _tarefas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  final TarefaDao _dao = TarefaDao();

  Livro? _livroTarefa = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
      ),
      body: FutureBuilder<List<Tarefa>>(
        initialData: [],
        future: Future.delayed(Duration(seconds: 1))
            .then((value) => _dao.findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Tarefa>? tarefas = snapshot.data;
                print(tarefas);
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final Tarefa tarefa = tarefas![index];
                      return ItemTarefa(context, tarefa);
                    },
                    itemCount: tarefas!.length
                );
              }
              break;
            default:
              return Center(
                child: Text("Nenhuma tarefa ..."),
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
            return FormTarefa();
          }));
          future.then((tarefa) {
            print("Tarefa retornada: ");
            print(tarefa);
            widget._tarefas.add(tarefa);
            setState(() {});
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget ItemTarefa(BuildContext context, Tarefa _tarefa) {
    print(_tarefa);
    return GestureDetector(
        onTap: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormTarefa(tarefa: _tarefa);
          }));
          future.then((value) => setState(() {}));
        },
        child: InkWell(
            splashColor: Colors.purple[200],
            onLongPress: () {
              LivrosDao _livroDao = new LivrosDao();
              _livroDao.findLivro(_tarefa.livro).then((value) {
                _livroTarefa = value;

                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text('Tarefa ' + _tarefa.descricao),
                          contentPadding: const EdgeInsets.all(20.0),
                          children: [
                            Text('Descrição: ' + _tarefa.obs),
                            Container(height: 10),
                            const Divider(
                              thickness: 2,
                            ),
                            Text(
                              'Pet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(height: 10),
                            Text('Titulo: ' +
                                (_livroTarefa != null
                                        ? _livroTarefa!.titulo
                                        : 'Não encontrado')
                                    .toString()),
                            Text('Autor: ' +
                                (_livroTarefa != null
                                    ? _livroTarefa!.autor
                                    : 'Não encontrado'.toString())),
                            Text((_livroTarefa != null
                                    ? (_livroTarefa!.anoLancamento != -1
                                            ? ('Ano de Lançamento: ' +
                                                _livroTarefa!.anoLancamento.toString())
                                            : '')
                                        .toString()
                                    : 'Não encontrado')
                                .toString()),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Text('Ok'),
                            )
                          ],
                        ));
              });
            },
            child: ListTile(
              leading: Icon(Icons.arrow_right_rounded, size: 50),
              title: Text(_tarefa.descricao),
              subtitle: Text(_tarefa.livro_titulo!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                      child: const Padding(
                          padding: EdgeInsets.all(8), child: Icon(Icons.edit)),
                      onTap: () {
                        final Future future = Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FormTarefa(tarefa: _tarefa);
                        }));
                        future.then((value) => setState(() {}));
                      }),
                  GestureDetector(
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.delete,
                              color: Color.fromARGB(255, 124, 30, 23))),
                      onTap: () {
                        showAlertDialog(
                            context,
                            "Excluir item",
                            "Deseja mesmo excluir este item?",
                            () => _excluir(context, _tarefa.id));

                        //_excluir(context, _tarefa.id);
                      }),
                ],
              ),
            )));
  }

  void _excluir(BuildContext context, int id) {
    _dao.delete(id).then((value) => setState(() {}));
  }
}
