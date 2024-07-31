import 'package:sqflite/sqflite.dart';
import '../model/tarefa.dart';
import 'app_database.dart';

class TarefaDao {

  static const String _tableName = 'tarefas';
  static const String _id = 'id';
  static const String _descricao = 'descricao';
  static const String _obs = 'obs';
  static const String _livro = "livro";

  static const String tableSQL = 'CREATE TABLE livros ('
      + ' id INTEGER PRIMARY KEY, '
      + ' titulo TEXT,'
      + ' anoLancamento INTEGER,'
      + ' autor TEXT,'
      + ' editora TEXT);';


  static const String tableSQL2 = 'CREATE TABLE tarefas ('
      'id INTEGER PRIMARY KEY, '
      'descricao TEXT, '
      'obs TEXT, '
      '$_livro INTEGER, '
     'FOREIGN KEY ($_livro) REFERENCES livros(id) '
      ');';


  Map<String, dynamic> toMap(Tarefa tarefa){
    final Map<String, dynamic> tarefaMap  = Map();
    tarefaMap[_descricao] = tarefa.descricao;
    tarefaMap[_obs] = tarefa.obs;
    tarefaMap[_livro] = tarefa.livro;
    return tarefaMap;
  }

  Future<int> save(Tarefa tarefa) async{
      final Database db = await getDatabase();
      Map<String, dynamic> tarefaMap = toMap(tarefa);
      return db.insert(_tableName, tarefaMap);
  }

  Future<int> update(Tarefa tarefa) async {
    final Database db = await getDatabase();
    Map<String, dynamic> tarefaMap = toMap(tarefa);
    return db.update(_tableName, tarefaMap, where: 'id = ?',
        whereArgs: [tarefa.id]);
  }

  Future<int> delete(int id) async{
    final Database db = await getDatabase();
    return db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
  }

  List<Tarefa> toList(List<Map<String, dynamic>> result){
    final List<Tarefa> tarefas = [];
    for (Map<String, dynamic> row in result){
      final Tarefa tarefa = Tarefa(row[_id], row[_descricao], row[_obs], row[_livro], row["livro_titulo"]);
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Tarefa>> findAll() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery(''
        'SELECT t.id, t.descricao, t.obs, t.livro, l.titulo as livro_titulo, l.anoLancamento, l.autor, l.editora '
        'FROM tarefas t, livros l '
        'WHERE t.livro = l.id;'
    );
    List<Tarefa> tarefas = toList(result);
    return tarefas;
  }
}