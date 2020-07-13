class Anotacao{

  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo,this.descricao, this.data);

  Anotacao.fromMap(Map map){
    this.titulo = map['titulo'];
    this.descricao = map['descricao'];
    this.data = map['data'];

    if(map['id'] != null){
      this.id = map['id'];
    }
  }

  Map toMap(){

    Map<String, dynamic> regist ={
      'titulo' : this.titulo,
      'descricao' : this.descricao,
      'data' : this.data
    };

    if (id != null){
      regist['id'] = this.id;
    }

    return regist;
    
  }
}