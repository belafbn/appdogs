import 'package:flutter/material.dart';
import 'package:projeto/components/fieldText.dart';
import 'package:projeto/database/livro_dao.dart';
import '../../model/livro.dart';
import '../../components/editor.dart';

class FormLivro extends StatefulWidget {
  final Livro? livro; // pode chegar com valor nulo null
  FormLivro({this.livro}); // {} -> opcionalidade

  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerAutor = TextEditingController();
  final TextEditingController _controllerEditora = TextEditingController();
  final TextEditingController _controllerAnoLancamento = TextEditingController();
  int? _editId;
  @override
  State<StatefulWidget> createState() {
    return FormLivrosState();
  }
}


class FormLivrosState extends State<FormLivro> {
  int? _id; // pode conter valor nulo

  @override
  void initState() {
    super.initState();

    if (widget.livro != null) {
      //significa que é uma alteração
      widget._editId = widget.livro!.id;
      widget._controllerAutor.text = widget.livro!.autor;
      widget._controllerEditora.text = widget.livro!.editora;
      widget._controllerAnoLancamento.text = widget.livro!.anoLancamento.toString();
      widget._controllerTitulo.text = widget.livro!.titulo;
    }
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
        title: Text("Editar Livro"),
      ),
      body: Column(
        children: [
          Field(widget._controllerTitulo, "Título", "Indique o título",
              Icons.title, maxLength: 30, ),
          Field(widget._controllerAutor, "Autor", "Indique o/a Autor/Autora",
              Icons.person, maxLength: 30,),
          Field(widget._controllerEditora, "Editora", "Indique a editora",
              Icons.edit_note_outlined, maxLength: 30,),
          Field(widget._controllerAnoLancamento, "Ano de Lançamento", "Indique o ano de lançamento",
              Icons.new_releases_outlined, maxLength: 4,),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
              onPressed: () {
                if (!_fieldErrors(widget._controllerTitulo) && !_fieldErrors(widget._controllerAutor)) {
                  criarLivro();
                } else {
                  print("campos inválidos");
                }
              },
              child: Text(
                'Salvar',
                style: Theme.of(context).textTheme.headline6
              ),
            ),
          )
        ],
      ),
      //floatingActionButton: FloatingActionButton(
      /*  //onPressed: () {
          criarTarefa(context);
        },
        child: Icon(Icons.save),
      ),*/
    );
  }

  void criarLivro() {
    LivrosDao _dao = LivrosDao();
    String _snackBarText = '';

    if (widget._editId != null) {
      final _livro = Livro(widget._editId!, widget._controllerTitulo.text, widget._controllerAutor.text, widget._controllerEditora.text, int.parse(widget._controllerAnoLancamento.text));
      _snackBarText = 'Livro editado';

      _dao.update(_livro)
          .then((id) => Navigator.pop(context,_livro));

    } else {
      final _livro = Livro(0,widget._controllerTitulo.text, widget._controllerAutor.text, widget._controllerEditora.text, int.parse(widget._controllerAnoLancamento.text));

      _snackBarText = 'Livro criado';
      _dao.save(_livro)
          .then((id) {
        Navigator.pop(context, _livro);
      });

    }

    final SnackBar snackBar = SnackBar(
      content: Text(_snackBarText),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
