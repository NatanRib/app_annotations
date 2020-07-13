import 'package:app_anotacoes/models/anotacao.dart';
import 'package:flutter/material.dart';
import 'package:app_anotacoes/helper/anotacao_helper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

var themeColor = Colors.green[600];
var secundaryColor = Colors.green[700];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  

  _salvarAnotacao() async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    _tituloController.clear();
    _descricaoController.clear();

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());//date time now recupera a data e hr atula
    //posso passar como string pq o banco salva com data
    int resultado = await _db.salvarRegistro(anotacao);
    print('salvar anotacao ' + resultado.toString());
  }

  _recuperaAnotacoes() async {
    List anot = await _db.recuperaRegistro();
    List<Anotacao> listaTemp = List<Anotacao>();

    for(var anotacao in anot){
      listaTemp.add(Anotacao.fromMap(anotacao));
    }
    setState(() {
      _anotacoes = listaTemp;
    });
    print(_anotacoes.toString());
  }

  _formataData(String data){

    initializeDateFormatting('pt_BR');

    var dataConvertida = DateTime.parse(data);
    var formatador = DateFormat.yMd('pt_BR');

    return formatador.format(dataConvertida).toString();
  }

  @override
  void initState() {
    _recuperaAnotacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Anotações'),
        backgroundColor: themeColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index){
                return Card(
                  child: Dismissible(
                    direction: DismissDirection.horizontal,
                    key: Key(DateTime.now().toString()),
                    background: Container(
                      padding: EdgeInsets.all(15),
                      color: Colors.yellow[600],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.edit)
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.delete)
                        ],
                      ),
                      color: Colors.red,
                    ),
                    onDismissed: (direcao){
                      if (direcao == DismissDirection.endToStart){
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Deseja apagar a anotação:'),
                              content: Text(_anotacoes[index].titulo),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: (){
                                    _db.apagaRegistro(_anotacoes[index].id);
                                    _recuperaAnotacoes();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Sim',
                                    style: TextStyle(
                                      color: themeColor
                                    ),
                                  
                                  ),
                                ),
                                FlatButton(
                                  onPressed: (){  
                                    _recuperaAnotacoes();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Não',
                                    style: TextStyle(
                                      color: themeColor
                                    ),
                                  ),
                                ),
                              ],

                            );
                          }
                        );
                      }else{
                        var tituloEdControler = TextEditingController(text: '${_anotacoes[index].titulo}');
                        var descricaoEdControler = TextEditingController(text: '${_anotacoes[index].descricao}');

                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Deseja Editar a anotação:'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  Text(
                                    _anotacoes[index].titulo,
                                    textAlign: TextAlign.center,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Titulo'
                                      ),
                                    autofocus: true,
                                    enableInteractiveSelection: false,
                                    controller: tituloEdControler
                                  ),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Descrição'
                                      ),
                                      enableInteractiveSelection: false,
                                      controller: descricaoEdControler
                                    ),
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            _db.atualizaRegistro(
                                              tituloEdControler.text,
                                              descricaoEdControler.text, 
                                              DateTime.now().toString(),
                                              _anotacoes[index].id
                                            );
                                            _recuperaAnotacoes();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Salvar',
                                            style: TextStyle(
                                              color: themeColor
                                            ),  
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            _recuperaAnotacoes();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: themeColor
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            );
                          }
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(_anotacoes[index].titulo),
                      subtitle: Text("${_formataData(_anotacoes[index].data)} - ${_anotacoes[index].descricao}"),
                    ),
                  ),
                );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return  AlertDialog(
                title: Text('Adcionar anotação'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _tituloController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'anotação'
                      ),
                    ),
                    TextField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        labelText: 'descrição'
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Material(
                      child: MaterialButton(
                        color: secundaryColor,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                    ),
                      Material(
                      child: MaterialButton(
                        color: secundaryColor,
                        onPressed: (){

                          _salvarAnotacao();
                          _recuperaAnotacoes();

                          Navigator.pop(context);
                        },
                        child: Text('Salvar'),
                      ),
                    )
                ],
              );
            },
            
          );
        },
        backgroundColor: secundaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}