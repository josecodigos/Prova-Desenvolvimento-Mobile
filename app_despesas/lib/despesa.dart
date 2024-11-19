class Despesa {
  String titulo;
  String descricao;
  DateTime data;
  double valor;

  Despesa({
    required this.titulo, 
    required this.descricao, 
    required this.data, 
    required this.valor
  });

  Map<String, dynamic> toMap(){
    return{
      'id': map['id'],
      'titulo': map['titulo'],
      'descricao': map['descricao'],
      'data': map['data'],generator.toIso8601String(),
      'valor': map['valor']
    }
  }
}