import 'package:sqflite/sqflite.dart';
import '../model/livro.dart';
import 'app_database.dart';

class LivrosDao {

  static const String _tableName = 'livros';
  static const String _id = 'id';
  static const String _titulo = 'titulo';
  static const String _autor = 'autor';
  static const String _editora = "editora";
  static const String _anoLancamento = "anoLancamento";



  Map<String, dynamic> toMap(Livro tarefa){
    final Map<String, dynamic> livroMap  = Map();
    livroMap[_titulo] = tarefa.titulo;
    livroMap[_autor] = tarefa.autor;
    livroMap[_editora] = tarefa.editora;
    livroMap[_anoLancamento] = tarefa.anoLancamento;
    return livroMap;
  }

  Future<int> save(Livro livro) async{
      final Database db = await getDatabase();
      Map<String, dynamic> livroMap = toMap(livro);
      return db.insert(_tableName, livroMap);
  }

  Future<int> update(Livro livro) async {
    final Database db = await getDatabase();
    Map<String, dynamic> livroMap = toMap(livro);
    return db.update(_tableName, livroMap, where: 'id = ?',
        whereArgs: [livro.id]);
  }

  Future<int> delete(int id) async{
    final Database db = await getDatabase();
    return db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
  }

  List<Livro> toList(List<Map<String, dynamic>> result){
    final List<Livro> livros = [];
    for (Map<String, dynamic> row in result){
      final Livro livro = Livro(row[_id], row[_titulo], row[_autor], row[_editora], row[_anoLancamento]);
      livros.add(livro);
    }
    return livros;
  }

  Future<List<Livro>> findAll({int? id}) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Livro> livros = toList(result);
    return filterLivros(livros, id: id);
  }

  List<Livro> filterLivros(List<Livro> livros, {int? id}) {
    return livros.where((it) {
      if (it.id == id) return true;
      if (it.anoLancamento != -1) return true;
      return false;
    }).toList();
  }
  Future<Livro> findLivro(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('livros', where: 'livros.id = $id');

    List<Livro> livro = toList(result);

    return livro.first;
  }
}