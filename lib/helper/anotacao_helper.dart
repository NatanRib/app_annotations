import 'package:app_anotacoes/models/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class AnotacaoHelper{

  static final tableName = 'anotacoes'; 
  
  //padrao singleton para apenas ter uma instancia dessa classe em memoria
  
  static final AnotacaoHelper _singleton = AnotacaoHelper._internal();
   
  factory AnotacaoHelper(){
    return _singleton;
  }

  AnotacaoHelper._internal();
  

  iniciaBd() async{

    final pathBd = join( await getDatabasesPath() , 'bd_anotacoes.bd');
    final sql = 'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)';
    
    var db = await openDatabase(
      pathBd,
      version: 1,
      onCreate: (db, lastVersion){
        db.execute(sql);
      }
    );
    print('aberto: ' + db.isOpen.toString());
   
    return db;
  }

  Future<int> salvarRegistro(Anotacao anotacao) async{

    var _db = await iniciaBd();

    int id = await _db.insert(
      //retorno é o id
      tableName,
      anotacao.toMap()
    );
    return id;
  }

  Future<List> recuperaRegistro() async{

    var _db = await iniciaBd();

    String sql = 'SELECT * FROM $tableName ORDER BY data ASC';

    List anotacoes = await _db.rawQuery(sql);

    return anotacoes;
  }

  Future<int> apagaRegistro(int id) async{

    var _db = await iniciaBd();

    int afetado = _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id]
    );

    return afetado;
  }

  Future <int> atualizaRegistro(String titulo, String descricao,String data, int id) async{
    
    var _db = await iniciaBd();
    
    Map<String,dynamic> values = {
      'titulo' : titulo,
      'descricao' : descricao,
      'data' : data
    };

    int idAtualizado = await _db.update(
      tableName, 
      values,
      where: 'id = ?',
      whereArgs: [id]
    );

    return idAtualizado;
  }

  limparTabela() async{
    var _db = await iniciaBd();
    var del = await _db.delete(tableName);

    return del;
  }

}