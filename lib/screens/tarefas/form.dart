import 'package:flutter/material.dart';
import 'package:projeto/database/tarefa_dao.dart';
import '../../model/tarefa.dart';
import '../../components/editor.dart';
import '../../model/livro.dart';
import 'package:projeto/database/livro_dao.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa; // pode chegar com valor nulo null
  FormTarefa({this.tarefa}); // {} -> opcionalidade

  final TextEditingController _controladorTarefa = TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  int? _id; // pode conter valor nulo

  @override
  void initState() {
    super.initState();

    getLivros();
    print(widget.tarefa);
    if (widget.tarefa != null) {
      //significa que é uma alteração
      _editId = widget.tarefa!.id;
      widget._controladorTarefa.text = widget.tarefa!.descricao;
      widget._controladorObs.text = widget.tarefa!.obs;
      _selectValue = widget.tarefa!.livro.toString() ?? null;
    }
  }

  String? _selectValue = null;
  int? _editId;
  List<Livro> _livrosList = [];

  void getLivros() async {
    LivrosDao livrosDao = LivrosDao();

    List<Livro> res = await livrosDao.findAll(id: widget.tarefa?.livro ?? null);

    setState(() {
      _livrosList = res;
    });
  }

  bool _fieldErrors(TextEditingController controller) {
    final text = controller.value.text;
    if (text.isEmpty) {
      return true;
    }
    if (text.length < 3) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Tarefa"),
      ),
      body: Column(
        children: [
          Editor(widget._controladorTarefa, "Tarefa", "Indique a tarefa",
              Icons.label_important_outline),
          Editor(widget._controladorObs, "Observação", "Indique a observação",
              Icons.assignment),
          buildSelectField(),
          Container(height: 20,),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  backgroundColor: Colors.purple[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                if (!_fieldErrors(widget._controladorTarefa) &&
                    !_fieldErrors(widget._controladorObs) &&
                    _selectValue != null) {
                  criarTarefa();
                } else {
                  print("campos inválidos");
                  final SnackBar snackBar = SnackBar(
                    content: Text('Existem campos não preenchidos!',
                        style: TextStyle(color: Colors.red[600])),
                    //backgroundColor: Colors.red[600],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          )
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

  void criarTarefa() {
    TarefaDao _dao = TarefaDao();
    String _snackBarText = '';
    print(_editId);
    if (_editId != null) {
      final _tarefaCriada = Tarefa(_editId!, widget._controladorTarefa.text,
          widget._controladorObs.text, int.parse(_selectValue!), null);
      _snackBarText = 'Tarefa editada';

      _dao.update(_tarefaCriada).then((id) => Navigator.pop(context));
    } else {
      final _tarefaCriada = Tarefa(0, widget._controladorTarefa.text,
          widget._controladorObs.text, int.parse(_selectValue!), null);

      _snackBarText = 'Tarefa criada';
      _dao.save(_tarefaCriada).then((id) {
        Navigator.pop(context);
      });
    }

    final SnackBar snackBar = SnackBar(
      content: Text(_snackBarText),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Widget buildSelectField() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Expanded(
            child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      value: _selectValue,
                      iconSize: 30,
                      icon: Icon(Icons.expand_more),
                      style: const TextStyle(color: Colors.black),
                      //style: AppTheme.typo.formText
                      hint: const Text('Selecione um livro'),
                      onChanged: (String? value) {
                        setState(() {
                          _selectValue = value!.toString();
                        });
                      },
                      items: _livrosList.map((Livro livro) =>
                          DropdownMenuItem<String>(
                            value: livro.id.toString(),
                            child: Text(livro.titulo),
                          )
                      ).toList() ?? [],
                    )
                )
            )
        )

    );
  }
}
