import 'package:projeto/database/tarefa_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {

  const String tableSQL3 = 'CREATE TABLE cursos ('
      'id INTEGER PRIMARY KEY, '
      'nome TEXT, '
      'descricao TEXT )';

  final String path = join(await getDatabasesPath(), 'dbtarefas.db');
  return openDatabase(path,
      onCreate: (db, version){
        db.execute(TarefaDao.tableSQL);
        db.execute(TarefaDao.tableSQL2);
        print('on create');
      },
      onUpgrade: (db, oldVersion, newVersion) async{
         var batch = db.batch();
         print("Versão antiga: "+ oldVersion.toString());
         print("Versão nova: " + newVersion.toString());
         if (newVersion == 2){
           batch.execute(TarefaDao.tableSQL2);
         }
         print("criando nova tabela");
         await batch.commit();
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete
  );
}
